;;; rl-lang-cpp.el --- C and C++ with clangd, clang-format and CMake -*- lexical-binding: t; -*-

;;; Commentary:
;; The stack is Eglot (rl-lsp.el) plus clangd, which answers completion,
;; jumps, references, rename and -- when the project exports a compilation
;; database -- the same diagnostics the build produces.  Everything in this
;; module either feeds that server or formats with the tool the project's CI
;; formats with; nothing here talks to a compiler directly.
;;
;; Deliberately not installed:
;; - lsp-mode.  Eglot is built in and rl-lsp.el is this config's only client.
;; - rtags, ggtags, counsel-gtags, company-clang, `semantic'.  All of them
;;   answer "where is this symbol" from a tag file, which is a worse clangd.
;;   The `ctags' on this machine is also the BSD one from the Command Line
;;   Tools -- `ctags --version' fails on it -- so that family could not use it
;;   either without `brew install universal-ctags'.
;; - a Flycheck clang-tidy checker.  clangd reports, and CI runs the tidy
;;   script over the whole tree; two engines over one translation unit is the
;;   thing rl-lsp.el exists to prevent.  C++ picks `rl-eglot-let-server-report'.
;; - google-c-style.  It pins a style, and the style lives in .clang-format.
;; - dap-mode / dape / gdb.  There is no debugger on this machine to talk to:
;;   no `gdb', no lldb-dap (only the `lldb' CLI and the built-in `gud').  The
;;   missing piece is a debug adapter, not an Emacs package, so it stays out
;;   until stepping through a crash beats the log line.
;;
;; Two facts about the toolchain that are not Emacs's fault, and that no
;; package fixes:
;;
;; - clangd needs the compilation database.  CMake writes one with
;;   CMAKE_EXPORT_COMPILE_COMMANDS, and a .clangd file says which build
;;   directory holds it.  Without it clangd invents flags and reports errors
;;   its own invention: headers the build finds are "not found", and the
;;   standard the project compiles with is not the one the server assumes.
;; - The clangd on the PATH here is Apple's, while clang-format and clang-tidy
;;   come from Homebrew's LLVM, which is not on the PATH.  That is the whole
;;   reason `rl-cpp-find-program' exists: formatting through the editor has to
;;   use the same binary the project's format script gates CI with, or the two
;;   disagree and the build wins.

;;; Code:

(defgroup rl-cpp nil
  "C and C++ support."
  :group 'languages
  :prefix "rl-cpp-")

;;; Finding the toolchain
;; Eglot finds clangd on the PATH by itself, so only the tools that are *not*
;; on the PATH need a lookup.

(defvar rl-cpp--llvm-bin-dir nil
  "Cached bin directory of Homebrew's LLVM formula, or nil.
Nil is also the answer when brew or the formula is missing, which is
acceptable because this is only called where it runs once per session.")

(defun rl-cpp-llvm-bin-dir ()
  "Return Homebrew's LLVM bin directory, or nil when there is none.
One `brew' process call per call, so call it from code that runs once --
loading `clang-format' and `make doctor' -- and never from a hook."
  (unless rl-cpp--llvm-bin-dir
    (when-let* ((brew (executable-find "brew")))
      (let ((default-directory "/"))
        (with-temp-buffer
          (when (zerop (process-file brew nil t nil "--prefix" "llvm"))
            (let ((bin (expand-file-name "bin" (string-trim (buffer-string)))))
              (when (file-directory-p bin)
                (setq rl-cpp--llvm-bin-dir bin))))))))
  rl-cpp--llvm-bin-dir)

(defun rl-cpp--newest-versioned (name)
  "Newest executable named NAME-N (clang-format-23) on `exec-path', or nil."
  (let ((newest nil)
        (newest-number 0))
    (dolist (dir exec-path)
      (when-let* ((files (ignore-errors (directory-files dir))))
        (dolist (file files)
          (when (string-match (concat "^" (regexp-quote name) "-\\([0-9]+\\)") file)
            (let ((number (string-to-number (match-string 1 file))))
              (when (> number newest-number)
                (setq newest-number number
                      newest (expand-file-name file dir))))))))
    (and newest (executable-find newest) newest)))

(defun rl-cpp-find-program (name)
  "Return the absolute path of clang toolchain program NAME, or nil.
Three places, in this order: NAME on `exec-path', NAME inside Homebrew's LLVM
bin, then the highest NAME-N on `exec-path'.  A name you put on the PATH beats
a directory guessed here, because that is a choice; between two guesses the
newer tool wins, because the reason a pinned toolchain is usually not on the
PATH is that the system already ships an older program with the same name.
Override by setting the program's own option, e.g.
`clang-format-executable', in `modules-private/'."
  (or (executable-find name)
      (let ((dir (rl-cpp-llvm-bin-dir)))
        (and dir (executable-find (expand-file-name name dir))))
      (rl-cpp--newest-versioned name)))

(defun rl-cpp-clang-format-version (&optional executable)
  "Version of clang-format EXECUTABLE as a string, for `make doctor'."
  (when-let* ((exe (or executable (rl-cpp-find-program "clang-format"))))
    (let ((default-directory "/"))
      (ignore-errors
        (with-temp-buffer
          (process-file exe nil t nil "--version")
          (goto-char (point-min))
          (and (re-search-forward "version +\\([0-9][0-9.]*\\)" nil t)
               (match-string 1)))))))

;;; Modes and their settings
(defun rl-cpp-server-reports ()
  "Hand this buffer's diagnostics to clangd.  See rl-lsp.el.
The alternative is Flycheck, whose C/C++ checker is a plain
`clang++ -fsyntax-only' fed by hand, while the include paths and the standard
of a CMake project live in CMake.  clangd reads the same compile_commands.json
the build reads, so it is strictly more.  The hook is buffer-local and tests
`eglot-managed-p', so a C++ buffer with no server keeps Flycheck."
  (add-hook 'eglot-managed-mode-hook #'rl-eglot-let-server-report nil t))

(defun rl-cpp-mode ()
  "Settings shared by every C and C++ mode this configuration uses.
Bound to the four mode hooks by name rather than to `c-mode-common-hook',
which is also the hook of Java and Objective-C: `make doctor' reads each
mode's own hook to say whether a server starts by itself, and a hook shared
with Java would make that report lie.

Run before `eglot-ensure' on the same hook, which is what lets
`rl-cpp-server-reports' install its hook before the server connects."
  (subword-mode 1)                       ; FooBarMethod is four words, not one
  (setq fill-column 100)                 ; the width the .clang-format files use
  ;; Buffer-local minor mode, and its predicate (`clang-format-on-save-p')
  ;; refuses to touch a buffer with no .clang-format above it, so this cannot
  ;; reformat a stranger's source on save.  `C-c l f' still asks the server.
  (when (require 'clang-format nil t)
    (clang-format-on-save-mode 1)
    ;; Capital F next to `eglot-format-buffer' on C-c l f: this one runs the
    ;; pinned clang-format and only touches the region or the statement here.
    (local-set-key (kbd "C-c l F") #'clang-format-region))
  (rl-cpp-server-reports))

;; `rl-treesit.el' installs the grammars and Emacs installs the
;; `c-mode -> c-ts-mode' remap itself, so a missing grammar means the classic
;; mode below, not a broken buffer.
(use-package c-ts-mode
  :ensure nil
  :custom
  ;; Two.  Not because Emacs knows the project's style -- it does not read
  ;; .clang-format -- but because every C++ tree on this machine that has a
  ;; .clang-format now says two, and this value only decides what TAB does
  ;; between saves, where the on-save formatter above decides what the file
  ;; ends up as.  It was 4 while BudgetKite was 4.
  (c-ts-indent-offset 2))

;;; The classic CC Mode, i.e. the fallback when the grammar is missing.
(use-package cc-mode
  :ensure nil
  :custom
  ;; The same number as above, deliberately: cc-mode's own default is
  ;; `set-from-style', which indents four in a C++ buffer, so leaving it alone
  ;; would make a buffer indent differently depending on whether the tree-sitter
  ;; grammar happens to be installed.
  (c-basic-offset 2))

;;; Formatting, with the binary the project's CI uses.
;; `eglot-format-buffer' (C-c l f) asks clangd, which formats with the library
;; built into the clangd on the PATH -- Apple's here.  The projects gate CI with
;; a pinned clang-format from Homebrew's LLVM, which is not on the PATH, so the
;; editor has to be pointed at that one or the two disagree and the build wins.
;;
;; `:commands' and not `:demand': the package only has to load when something
;; is being formatted, and `rl-cpp-mode' requires it explicitly, so that a
;; machine without it degrades to the server's formatter instead of erroring on
;; every file visit.  `clang-format-executable' is `:risky', which is why this
;; is a `setq' in `:config' rather than `:custom'.
(defvar clang-format-executable)

(use-package clang-format
  :commands (clang-format-buffer clang-format-region clang-format-on-save-mode)
  :config
  (when-let* ((exe (rl-cpp-find-program "clang-format")))
    (setq clang-format-executable exe)))

(dolist (hook '(c-mode-hook c++-mode-hook c-ts-mode-hook c++-ts-mode-hook))
  (add-hook hook #'rl-cpp-mode)
  (add-hook hook #'eglot-ensure))

;;; CMake
;; `cmake-ts-mode' is built into Emacs 31 and its grammar comes from
;; rl-treesit.el; CMake also ships its own `cmake-mode', which is the fallback
;; and the only thing here that knows `cmake --help'.
(defun rl-cpp--cmake-site-lisp ()
  "Directories where CMake installs cmake-mode.el, best guess first.
`make install' puts it in <prefix>/share/emacs/site-lisp/cmake and Homebrew
follows that, under the prefix and under the Cellar directory the symlink
came from.  The unresolved prefix comes first because it survives an upgrade."
  (when-let* ((exe (executable-find "cmake")))
    (delete-dups
     (mapcar (lambda (bin)
               (expand-file-name "share/emacs/site-lisp/cmake"
                                 (file-name-directory (directory-file-name bin))))
             (list (file-name-directory exe)
                   (file-name-directory (file-chase-links exe)))))))

(defun rl-cpp-cmake-mode-setup ()
  "Add CMake's own Emacs lisp directory to `load-path', and return it.
Nil when CMake ships no cmake-mode.el here, which is what a distro package
that splits the editors off does."
  (catch 'found
    (dolist (dir (rl-cpp--cmake-site-lisp))
      (when (file-exists-p (expand-file-name "cmake-mode.el" dir))
        (add-to-list 'load-path dir)
        (throw 'found dir)))
    nil))

(when (rl-cpp-cmake-mode-setup)
  ;; Mapped to `cmake-mode' on purpose: `treesit-enabled-modes' (rl-treesit.el)
  ;; installs the `cmake-mode -> cmake-ts-mode' remap when the grammar is
  ;; there, so this line is what runs when it is not.  Same shape as
  ;; yaml-mode in rl-lang-config.el.
  (use-package cmake-mode
    :ensure nil
    :mode ("CMakeLists\\.txt\\'" "\\.cmake\\'")))

;; The configuration files of this toolchain are YAML, and `.clang-format' is
;; YAML too (the clang-format docs call it a YAML table).  `yaml-mode' is what
;; rl-lang-config.el keeps, and the remap to `yaml-ts-mode' applies here as
;; well, so these files get whichever grammar is installed.
(dolist (entry '(("\\.clang-format\\'" . yaml-mode)
                 ("\\.clang-tidy\\'"   . yaml-mode)
                 ("\\.clangd\\'"       . yaml-mode)))
  (add-to-list 'auto-mode-alist entry))

(provide 'rl-lang-cpp)
;;; rl-lang-cpp.el ends here
