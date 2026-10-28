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
;; The report has several sections, because the kinds of absence behave
;; differently and only some of them are visible from inside a buffer.
;;
;;   A missing program on `exec-path' breaks one named feature and nothing else.
;;   A missing language server breaks nothing at all except that the buffer has
;;   no completion, no jumps and no diagnostics from a server: Eglot looks the
;;   major mode up, finds no program on the PATH, warns once and leaves the mode
;;   alone.  Servers are therefore reported separately, from
;;   `rl-doctor-lsp-modes' below, and that section is the one thing here you
;;   cannot find out from inside Emacs without asking Eglot itself.
;;   A package that is installed but named by no `use-package' form is activated
;;   at every start and does nothing, which is what a deleted form or a
;;   `:disabled t' leaves behind.
;;   Byte-code older than its source is invisible except as a slow start and a
;;   compiler warning about somebody else's code.

;;; Code:

(require 'package)
(require 'seq)

(declare-function eglot--lookup-mode "eglot")

(defconst rl-doctor-config-root
  (or (bound-and-true-p minimal-emacs-user-directory)
      user-emacs-directory)
  "Where the configuration lives, as opposed to where it keeps its state.
`user-emacs-directory' is `var/' in this configuration and the init files are
one level up, which is why `minimal-emacs-user-directory' is asked for first.")

(defconst rl-doctor-modules-dir
  (expand-file-name "modules" rl-doctor-config-root)
  "Where the public modules live, used to report byte-compilation status.")

(defconst rl-doctor-private-modules-dir
  (expand-file-name "modules-private" rl-doctor-config-root)
  "Where the private modules live.
Git ignores that directory, so a fresh checkout has an empty one and a hand-made
one may not exist at all.")

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
The program Eglot would run is looked up, not stored here.

Emacs Lisp is deliberately not listed: `eglot-server-programs' has no entry for
`emacs-lisp-mode' (checked against Emacs 31.1), so there is no server to install
or report here.  What a server adds elsewhere is built in for this language --
ElDoc for signatures, `xref' for jumps, `elisp-flymake-byte-compile' for
diagnostics -- which is also why no absence in this list is ever reported for
a .el buffer.")

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

;;; Third-party packages
;; `package-alist' is built from the installed packages and holds one entry per
;; package, with the version that won.  Two things are worth saying from it.
;; Which ones the config no longer names: `use-package' never uninstalls, so a
;; removed form leaves the package installed and activated at every start.  And
;; which ones have byte-code older than their source, because that turns a load
;; into a compile.

(defun rl-doctor-config-files ()
  "Config files that can contain a `use-package' form.
Both layers count.  `package.el' does not care which one names a package, so a
package wanted only by a private module (rbenv, rubocop, yari) is not an orphan
-- and every dependency of such a package is not one either.  Listing only
`modules/' reported five private packages and two of their dependencies as
inert."
  (append (directory-files rl-doctor-modules-dir t "\\.el\\'")
          (when (file-directory-p rl-doctor-private-modules-dir)
            (directory-files rl-doctor-private-modules-dir t "\\.el\\'"))
          (mapcar (lambda (file) (expand-file-name file rl-doctor-config-root))
                  '("init.el" "post-init.el" "pre-init.el"
                    "post-early-init.el" "modules-private.el"))))

(defun rl-doctor-referenced-packages ()
  "Sorted package names a `use-package' form in the config refers to.
This is a text search, not a macroexpansion: expanding every form to answer a
question about names is the wrong trade, and a name that survives only in a
comment is a name someone means to switch back on.  Both make the answer name
fewer orphans than the truth, which is the safe direction."
  (let (names)
    (dolist (file (rl-doctor-config-files))
      (when (file-readable-p file)
        (with-temp-buffer
          (insert-file-contents file)
          (goto-char (point-min))
          (while (re-search-forward "(use-package[ \t\n]+\\([^ \t\n()]+\\)" nil t)
            (push (match-string 1) names))
          ;; `:ensure (a b)' names packages without a `use-package' of its own.
          (goto-char (point-min))
          (while (re-search-forward ":ensure[ \t\n]+(\\([^)]*\\))" nil t)
            (dolist (name (split-string (match-string 1) "[ \t\n()]+" t))
              (push name names))))))
    (sort (delete-dups names) #'string<)))

;;; Byte-code older than its source
;; package.el unpacks a tarball whose .el and .elc were written in the same
;; second, and the .el can come out a few milliseconds *newer* than the .elc
;; beside it.  `load' reads a newer source as "the byte-code is stale": it uses
;; the source instead, compiles it, and prints whatever the compiler says about
;; code this config does not own.  That is where messages like
;;
;;   var/elpa/blamer-20251001.620/blamer.el: Warning: `when-let' is an obsolete
;;   macro (as of 31.1); use `when-let*' or `and-let*' instead.
;;
;; come from, and why they come back on every start.  Nothing is wrong with the
;; byte-code and patching a third-party source would be undone by the next
;; package update: only the timestamps are wrong, so `rl-doctor-fix-byte-code'
;; makes those agree and recompiles nothing, which leaves the native-compilation
;; cache alone.  Measured here: 108 of 316 libraries were affected, vertico.el
;; and corfu-popupinfo.el among them loaded at every start, and a start went from
;; 1.85 s to 1.67 s once they were loaded as byte-code.

(defun rl-doctor-stale-byte-code ()
  "List of (SOURCE . COMPILED) in `package-user-dir' whose byte-code is older.
Such a library is loaded from source, and recompiled, on every load.  Libraries
with no byte-code at all are not listed: that is normal for `*-autoloads.el'
and for theme files, which are too small to be worth compiling."
  (let (stale)
    (dolist (source (directory-files-recursively package-user-dir "\\.el\\'")
        (nreverse stale))
      (unless (string-match-p "-\\(?:autoloads\\|pkg\\)\\.el\\'" source)
        (let ((compiled (concat source "c")))
          (when (and (file-exists-p compiled)
                     (file-newer-than-file-p source compiled))
            (push (cons source compiled) stale)))))))

;;;###autoload
(defun rl-doctor-fix-byte-code ()
  "Make third-party byte-code newer than its source, so that `load' uses it.
See `rl-doctor-stale-byte-code' for what is wrong and why timestamps are the
right fix.  Run it again after installing or upgrading packages, which is what
puts the timestamps back out of order."
  (interactive)
  (let ((n 0))
    (dolist (pair (rl-doctor-stale-byte-code))
      (set-file-times (cdr pair)
                      (time-add (file-attribute-modification-time
                                 (file-attributes (car pair)))
                                (seconds-to-time 1)))
      (setq n (1+ n)))
    (message "%d byte-compiled file%s made newer than its source"
             n (if (= n 1) " was" " were"))))

(defun rl-doctor-configured-packages (names)
  "Package names reachable from NAMES, following `package-desc-reqs'.
An installed package that nothing names is only interesting if nothing that IS
named depends on it either: `package.el' installs dependencies next to the
packages this config asks for, and dash, f, s and ht are not leftovers."
  (let ((seen nil)
        (todo (copy-sequence names)))
    (while todo
      (let* ((name (intern (pop todo)))
             (entry (assq name package-alist)))
        (unless (member (symbol-name name) seen)
          (push (symbol-name name) seen)
          (dolist (desc (cdr entry))
            (dolist (req (ignore-errors (package-desc-reqs desc)))
              (push (symbol-name (car req)) todo))))))
    seen))

(defun rl-doctor-package-lines ()
  "Report installed packages, orphans, and stale byte-code, as lines."
  (unless package-alist
    (require 'package)
    (package-load-all-descriptors))
  (let* ((referenced (rl-doctor-referenced-packages))
         (named (seq-filter (lambda (name) (assq (intern name) package-alist))
                            referenced))
         (reachable (rl-doctor-configured-packages named))
         (orphans (sort (seq-remove (lambda (name)
                                      (member (symbol-name name) reachable))
                                    (mapcar #'car package-alist))
                        (lambda (a b) (string< (symbol-name a) (symbol-name b))))))
    (list "Third-party packages:"
          (format "  installed:                %d in %s"
                  (length package-alist) package-user-dir)
          (format "  named by a `use-package': %d, plus %d they depend on"
                  (length named) (- (length reachable) (length named)))
          (if orphans
              (format "  installed, wanted by nothing: %s (no `use-package' names it, no wanted package declares it)\n%s"
                      (length orphans)
                      (mapconcat (lambda (name)
                                   (format "    %-22s %s"
                                           name
                                           (let ((desc (cadr (assq name package-alist))))
                                             (if desc
                                                 (mapconcat #'number-to-string
                                                            (package-desc-version desc) ".")
                                               "?"))))
                                 orphans "\n"))
            "  installed, wanted by nothing: none")
          (let ((n (length (rl-doctor-stale-byte-code))))
            (format "  byte-code older than source: %d %s%s"
                    n (if (= n 1) "library" "libraries")
                    (if (zerop n) ""
                      " -- loads from source and recompiles every start; M-x rl-doctor-fix-byte-code"))))))

;;; What a `use-package' form can silently fail to do
;; `:after PACKAGE' defers everything in the form -- `:init' included -- until
;; PACKAGE loads.  That is the right shape for a package that extends another,
;; and the wrong shape for a mode you always want: the form then never runs, and
;; no error says so.  This section is for the settings that are set, correct, and
;; have no effect.

;;; The private layer, which a fresh checkout does not have
;; `post-init.el' loads `modules-private.el' last and skips it silently when it is
;; absent, so "no private layer yet" and "my private modules stopped loading" look
;; the same from inside Emacs.  The second is the case worth a line of its own:
;; files in `modules-private/' that nothing requires, which is what a half-copied
;; loader leaves behind.

(defun rl-doctor-private-layer-line (&optional root)
  "Describe the state of the private layer, as one report line.
ROOT defaults to the configuration directory, so both branches can be run
against a scratch directory instead of moving a real file."
  (let* ((root (or root rl-doctor-config-root))
         (loader (expand-file-name "modules-private.el" root))
         (dir (expand-file-name "modules-private" root))
         ;; `\\.el\\'' cannot match the tracked `*.el.example' files.
         (modules (when (file-directory-p dir)
                    (directory-files dir t "\\.el\\'")))
         (count (length modules)))
    (format "  private layer:              %s"
            (cond
             ((and (file-exists-p loader) (> count 0))
              (format "modules-private.el, %d private %s"
                      count (if (= count 1) "module" "modules")))
             ((file-exists-p loader)
              "modules-private.el, and nothing in modules-private/ to require")
             (modules
              (format "%d file%s in modules-private/ that nothing requires: %s"
                      count (if (= count 1) "" "s")
                      (mapconcat #'file-name-nondirectory
                                 (seq-take modules 4) ", ")))
             (t
              "absent; cp modules-private.el.example modules-private.el")))))

(defun rl-doctor-config-lines ()
  "Report configured state that a buffer cannot show you."
  (list "Configured, and whether it took effect:"
        (format "  window system:              %s"
                (if window-system
                    (format "%s%s" window-system (if (display-graphic-p) "" " (no graphics)"))
                  "none (batch or TTY): frame parameters in `initial-frame-alist' are dropped"))
        (format "  doom-modeline-mode:         %s%s"
                (if (bound-and-true-p doom-modeline-mode) "on" "OFF")
                (if (featurep 'doom-modeline) ""
                  " -- its form has `:demand t', so OFF means it failed to load"))
        (format "  global-blamer-mode:         %s%s"
                (if (bound-and-true-p global-blamer-mode) "on" "not started")
                (if (featurep 'blamer) ""
                  " -- deferred to a 0.5 s idle timer, which does not run in batch"))
        (rl-doctor-private-layer-line)
        (format "  exec-path-from-shell:       %s"
                (if (featurep 'exec-path-from-shell)
                    (format "ran, %d variables (one shell per GUI start)"
                            (length (bound-and-true-p exec-path-from-shell-variables)))
                  "skipped (needs macOS and a window system or daemon)"))
        ;; Worth one line because the cheap shell call above is what it is cheap
        ;; by: the directories it reads come from ~/.zshenv only, so a Dock-
        ;; launched Emacs can resolve `ruby' outside rbenv and nothing else here
        ;; would say so.  A batch run inherits the terminal's PATH and so always
        ;; sees the shim -- which is also why this line is a GUI-only diagnostic.
        (format "  ruby resolves to:           %s%s"
                (or (executable-find "ruby") "not found")
                (let ((found (executable-find "ruby")))
                  (cond
                   ((null found) "")
                   ((file-in-directory-p found (expand-file-name "~/.rbenv/shims")) "")
                   (t " -- not the rbenv shim; see the `:if' in modules/rl-run.el"))))))

;;; The report

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
    (dolist (line (rl-doctor-package-lines))
      (push line lines))
    (push "" lines)
    (dolist (line (rl-doctor-config-lines))
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
