;;; check-load.el --- Fail when the configuration warns while it loads  -*- lexical-binding: t; -*-
;;; Commentary:
;; Run with: make check-load
;;
;; `use-package' wraps each form in a `condition-case' and turns a failure into
;; a warning.  That is the right behaviour interactively — one broken package
;; must not stop Emacs from starting — but it also means a form can be broken
;; for months and never be noticed.  The flycheck menu in rl-check.el was
;; broken exactly this way: `transient-define-prefix' rejected the suffix
;; syntax, use-package reported a warning during startup, and nobody read it.
;;
;; This file records every warning raised while the configuration loads and
;; makes the batch run exit non-zero if there was one.
;;
;; It must be loaded BEFORE the init files, so the advice is installed first:
;;
;;   emacs --init-directory DIR -Q --batch -l check-load.el \
;;       --load DIR/early-init.el --load DIR/init.el \
;;       --eval '(rl-check-load-report)' --kill

;;; Code:

(defvar rl-check-load--problems '()
  "Warnings seen during startup, most recent first, as (KIND MESSAGE).")

(defvar rl-check-load--messages '()
  "Error-like messages printed during startup, most recent first.
Some packages report a failure with `message' inside their own
`condition-case', so no warning is raised and the run still exits 0.  A line
like “Cannot load X: …” from web-mode is an example.")

(defconst rl-check-load--bad-message
  "\\`\\(Cannot \\|Error\\b\\|Failed\\b\\|Wrong \\|Invalid \\|Unable \\|Failed to\\)"
  "Regexp selecting the startup messages that mean something broke.")

(advice-add 'display-warning
            :before
            (lambda (kind message &optional _area)
              (push (list kind message) rl-check-load--problems)))

(advice-add 'message
            :before
            (lambda (format-string &rest args)
              (when (stringp format-string)
                (let ((text (condition-case nil
                                (apply #'format format-string args)
                              (error format-string))))
                  (when (string-match-p rl-check-load--bad-message text)
                    (push text rl-check-load--messages))))))

(defun rl-check-load-report ()
  "Print what went wrong while loading, and exit non-zero if anything did."
  (let ((problems (reverse rl-check-load--problems))
        (messages (reverse rl-check-load--messages)))
    (if (null problems)
        (princ "check-load: no warnings\n")
      (princ (format "check-load: %d warning(s):\n" (length problems)))
      (dolist (problem problems)
        (princ (format "  warning  %-12s %s\n" (car problem) (cadr problem)))))
    (if (null messages)
        (princ "check-load: no error-like messages\n")
      (princ (format "check-load: %d error-like message(s):\n" (length messages)))
      (dolist (text messages)
        (princ (format "  message  %s\n" text))))
    (unless (or (null problems) (null messages))
      (kill-emacs 1))))

;;; check-load.el ends here
