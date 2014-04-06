(emacs-require-package 'scala-mode2)


;; Bind the 'newline-and-indent' command to RET (aka 'enter')
(add-hook 'scala-mode-hook '(lambda ()
  (local-set-key (kbd "RET") 'newline-and-indent)
  (local-set-key (kbd "<backtab>") 'scala-indent:indent-with-reluctant-strategy)
))


(defun emacs-scala-mode-defaults ()
  (subword-mode +1))
(setq emacs-scala-mode-hook 'emacs-scala-mode-defaults)
(add-hook 'scala-mode-hook (lambda ()
                             (run-hooks 'emacs-scala-mode-hook)))


(provide 'emacs-scala)
