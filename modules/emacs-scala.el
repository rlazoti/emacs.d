(emacs-require-packages '(scala-mode2 ensime))

(require 'ensime)

(add-hook 'scala-mode-hook '(lambda ()
  (require 'whitespace)

	;; Bind the 'newline-and-indent' command to RET (aka 'enter')
	(local-set-key (kbd "RET") 'newline-and-indent)
	(local-set-key (kbd "<backtab>") 'scala-indent:indent-with-reluctant-strategy)

	;; sbt-find-definitions is a command that tries to find (with grep)
	;; the definition of the thing at point.
	(local-set-key (kbd "M-.") 'sbt-find-definitions)

	;; use sbt-run-previous-command to re-compile your code after changes
	(local-set-key (kbd "C-x '") 'sbt-run-previous-command)

	(local-set-key (kbd "M-<f6>") 'ensime-db-step)

	;; clean-up whitespace at save
	(make-local-variable 'before-save-hook)
	(add-hook 'before-save-hook 'whitespace-cleanup)

	;; but company-mode / yasnippet conflict. Disable TAB in company-mode with
	(define-key company-active-map [tab] nil)

	;; turn on highlight. To configure what is highlighted, customize
	;; the *whitespace-style* variable. A sane set of things to
	;; highlight is: face, tabs, trailing
	(whitespace-mode)
))

(defun emacs-scala-mode-defaults ()
  (subword-mode +1))

(setq emacs-scala-mode-hook 'emacs-scala-mode-defaults)
(add-hook 'scala-mode-hook 'ensime-scala-mode-hook)
(add-hook 'scala-mode-hook #'yas-minor-mode)

(provide 'emacs-scala)
