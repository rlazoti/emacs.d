;;; rl-doctor.el --- Report what this configuration is missing -*- lexical-binding: t; -*-
;;; Commentary:
;; The config degrades on purpose when something external is missing: no `rg'
;; means no deadgrep, no `pygmentize' means no shell highlighting, a missing
;; tree-sitter grammar means a plain major mode.  Those degradations are
;; deliberate but silent, so this module keeps one list of what is expected and
;; one command that says what is absent.
;;
;;   M-x rl-doctor        show the report in a buffer
;;   make doctor          print the same report in a terminal
;;
;; The list lives here rather than in the Makefile so both use the same
;; information, and so a program is recorded next to what breaks without it.
;;
;; There are two sections, because the two kinds of absence behave differently.
;; A missing program on `exec-path' breaks one named feature and nothing else. A
;; missing language server changes nothing at all except that the buffer has no
;; completion, no jumps and no diagnostics from a server: Eglot asks for a
;; program, finds none, warns once and leaves the major mode alone. Servers are
;; therefore reported separately, from `rl-doctor-lsp-modes' below.

;;; Code:

(declare-function eglot--lookup-mode "eglot")

(defconst rl-doctor-modules-dir
  (expand-file-name "modules"
                    (or (and (boundp 'minimal-emacs-user-directory)
                             minimal-emacs-user-directory)
                        user-emacs-directory))
  "Where the public modules live, used to report byte-compilation status.")

(defconst rl-doctor-programs
  '(("git"           . "Magit, project detection, treemacs git markers, consult-git-grep")
    ("rg"            . "deadgrep and consult-ripgrep")
    ("aspell"        . "ispell, which spell checks comments and Org")
    ("pygmentize"    . "shell syntax highlighting in shell buffers")
    ("ruby"          . "the rbenv shim, rubocop, yari")
    ("rbenv"         . "the Ruby PATH used by flycheck and eglot")
    ("rubocop"       . "flycheck's Ruby checker")
    ("node"          . "the runtime of every npm language server")
    ("multimarkdown" . "markdown-mode's document converter")
    ("pandoc"        . "document conversion between markdown and other formats"))
  "External programs the config uses, with what breaks without them.")

(defun rl-doctor-missing-programs ()
  "List of (PROGRAM . REASON) for programs that are not on `exec-path'."
  (seq-remove (lambda (entry) (executable-find (car entry)))
              rl-doctor-programs))

;;; Language servers
;; Eglot installs nothing and ships no server: it looks the buffer's
;; `major-mode' up in `eglot-server-programs', tries the candidate programs with
;; `executable-find', and starts the first one it finds.  Nothing is on the PATH
;; unless it was installed outside Emacs, so the useful question is not "do I
;; have Eglot" (the built-in one, always) but "what would `M-x eglot' manage to
;; find for this mode, and how would I install it".
;;
;; The program names are deliberately not written down here.  `eglot--lookup-mode'
;; plus the candidate function behind the entry answer that question the same way
;; `M-x eglot' does, so renaming a server upstream cannot make this report lie:
;; only the install hint can.  The modes are the ones this configuration visits,
;; which means the `-ts-mode' of a language with a grammar (rl-treesit.el).
;;
;; Whether a mode starts a server by itself is read from its own hook rather than
;; listed: `eglot-ensure' in the mode hook means automatic, anything else means
;; `M-x eglot' once per project (rl-lsp.el says which modes hook it).  One caveat,
;; and it is a consequence of the hook being the truth: the language modules are
;; deferred, so `python-ts-mode-hook' only carries `eglot-ensure' after
;; python.el has been loaded by visiting a Python file.  A cold session therefore
;; reports `M-x eglot' for a language that will start a server by itself as soon
;; as you open one of its files.  The installed column has no such caveat: it is
;; a PATH lookup, always exact.

(defconst rl-doctor-lsp-modes
  '((ruby-ts-mode . "gem install ruby-lsp")
    (python-ts-mode . "pip install pyright")
    (js-ts-mode . "npm install -g typescript-language-server typescript")
    (json-ts-mode . "npm install -g vscode-langservers-extracted")
    (css-ts-mode . "npm install -g vscode-langservers-extracted")
    (bash-ts-mode . "npm install -g bash-language-server")
    (yaml-ts-mode . "npm install -g yaml-language-server")
    (toml-ts-mode . "npm install -g @tombi/tombi")
    (dockerfile-ts-mode . "npm install -g dockerfile-language-server-nodejs")
    (go-ts-mode . "go install golang.org/x/tools/gopls@latest")
    (rust-ts-mode . "rustup component add rust-analyzer")
    (c-ts-mode . "clangd, from the Xcode Command Line Tools"))
  "Major modes to report a language server for, and how to install it.
One entry per server, keyed by the mode this configuration actually uses.
The program Eglot would run is looked up, not stored here.")

(defun rl-doctor--lsp-line (mode install)
  "Return the report line for MODE, suggesting INSTALL when it has no server."
  (let* ((entry (ignore-errors (eglot--lookup-mode mode)))
         ;; `eglot--lookup-mode' answers (LANGUAGES . CONTACT), where LANGUAGES
         ;; is the list of (MODE . LANGUAGE-ID) pairs the server covers.  The
         ;; language id of the mode asked about is the shortest honest label.
         (languages (car entry))
         (contact (cdr entry))
         (label
          (format "%s"
                  (or (cdr (or (assq mode languages) (car languages))) mode)))
         (program
          ;; A contact is either a candidate function (`eglot-alternatives',
          ;; which answers with (ABSPATH ARGS...) for the first candidate on the
          ;; PATH and signals when none is) or a plain (PROGRAM ARGS...) list,
          ;; which names a program but says nothing about it being installed.
          ;; A third shape, (HOST PORT), names no program and reports absent.
          (cond
           ((functionp contact) (car (ignore-errors (funcall contact nil nil))))
           ((and (consp contact) (stringp (car contact)))
            (executable-find (car contact)))
           (t nil)))
         (hook (intern (format "%s-hook" mode)))
         (autostart (and (boundp hook) (memq #'eglot-ensure (symbol-value hook)))))
    (format "  %-11s %-9s %-11s %s"
            label
            (if program "installed" "MISSING")
            (if autostart "automatic" "M-x eglot")
            ;; When it is there, which install won is the interesting part: a
            ;; rbenv shim and a Homebrew binary are the same name and not the
            ;; same version.  When it is not, the install hint is.  Both
            ;; branches above now answer with an absolute path.
            (if program program install))))

(defun rl-doctor-lsp-lines ()
  "Return one line per language in `rl-doctor-lsp-modes', plus a header."
  (require 'eglot)
  (cons "Language servers (what `M-x eglot' would find on the PATH right now):"
        (mapcar (pcase-lambda (`(,mode . ,install))
                  (rl-doctor--lsp-line mode install))
                rl-doctor-lsp-modes)))

(defun rl-doctor-report ()
  "Return the report as a list of lines."
  (let* ((missing (rl-doctor-missing-programs))
         (grammars (and (fboundp 'rl-treesit-missing)
                        (funcall 'rl-treesit-missing)))
         ;; Built in reverse: `push' is cheaper than appending.
         (lines (list
                 "" "External programs:"
                 (format "packages: %d in %s"
                         (length (directory-files package-user-dir t "^[^.]" t))
                         package-user-dir)
                 (format "config:   %s" user-emacs-directory)
                 (format "Emacs %s (%s)" (emacs-version) system-type))))
    (if missing
        (dolist (entry missing)
          (push (format "  MISSING  %-14s %s" (car entry) (cdr entry)) lines))
      (push "  all present" lines))
    (push "" lines)
    (dolist (line (rl-doctor-lsp-lines))
      (push line lines))
    (push "" lines)
    (push "Tree-sitter:" lines)
    (if grammars
        (dolist (g grammars)
          (push (format "  MISSING  %-14s M-x rl-treesit-install-missing" g) lines))
      (push "  every language in `rl-treesit-languages' has a grammar" lines))
    (push "" lines)
    (push "Compilation:" lines)
    (push (format "  native compiler: %s"
                  (if (fboundp 'native-comp-available-p)
                      (native-comp-available-p) 'unknown))
          lines)
    (push (format "  byte-compiled modules: %d of %d"
                  (length (directory-files rl-doctor-modules-dir t "\\.elc\\'" t))
                  (length (directory-files rl-doctor-modules-dir t "\\.el\\'" t)))
          lines)
    (nreverse lines)))

;;;###autoload
(defun rl-doctor ()
  "Show what this configuration is missing."
  (interactive)
  (let ((buffer (get-buffer-create "*rl-doctor*")))
    (with-current-buffer buffer
      (erase-buffer)
      (insert (mapconcat #'identity (rl-doctor-report) "\n") "\n"))
    (pop-to-buffer buffer)))

(provide 'rl-doctor)
;;; rl-doctor.el ends here
