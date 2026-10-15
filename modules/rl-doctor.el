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

;;; Code:

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
    ("pyright"       . "eglot's Python server")
    ("ruby"          . "the rbenv shim, rubocop, yari")
    ("rbenv"         . "the Ruby PATH used by flycheck and eglot")
    ("rubocop"       . "flycheck's Ruby checker")
    ("node"          . "eglot's JavaScript and TypeScript servers")
    ("multimarkdown" . "markdown-mode's document converter")
    ("pandoc"        . "document conversion between markdown and other formats"))
  "External programs the config uses, with what breaks without them.")

(defun rl-doctor-missing-programs ()
  "List of (PROGRAM . REASON) for programs that are not on `exec-path'."
  (seq-remove (lambda (entry) (executable-find (car entry)))
              rl-doctor-programs))

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
