(add-to-list 'package-pinned-packages '(ensime . "melpa-stable") t)

(emacs-require-packages '(scala-mode ensime))

(make-local-variable 'company-backends)
(setq company-backends
      '(ensime-company (company-keywords company-dabbrev-code company-etags company-yasnippet)))

;; show graphical bubbles for tooltips
(setq ensime-graphical-tooltips t)

;; ENSIME will try to create a config file automatically,
;; and update it when the project definition changes.
(setq ensime-auto-generate-config t)

;; For complex scala files
(setq max-lisp-eval-depth 50000)
(setq max-specpdl-size 5000)
(setq scala-indent:use-javadoc-style t)

(add-hook 'scala-mode-hook '(lambda ()
  (require 'ensime)
  (require 'whitespace)

  (show-paren-mode)
  (smartparens-mode)
  (yas-minor-mode)
  (company-mode)
  (ensime-mode)
  (subword-mode +1)

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

(provide 'emacs-scala)
