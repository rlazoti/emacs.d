(emacs-require-packages '(scala-mode2 ensime))

(require 'ensime)

;; Bind the 'newline-and-indent' command to RET (aka 'enter')
(add-hook 'scala-mode-hook '(lambda ()
															(local-set-key (kbd "RET") 'newline-and-indent)
															(local-set-key (kbd "<backtab>") 'scala-indent:indent-with-reluctant-strategy)
															))

(defun emacs-scala-mode-defaults ()
  (subword-mode +1))

(setq emacs-scala-mode-hook 'emacs-scala-mode-defaults)
(add-hook 'scala-mode-hook 'ensime-scala-mode-hook)
(add-hook 'scala-mode-hook #'yas-minor-mode)
(define-key company-active-map [tab] nil)

(provide 'emacs-scala)
