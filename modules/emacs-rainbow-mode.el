(emacs-require-package 'rainbow-mode)


(add-hook 'css-mode-hook 'my-css-mode-hook)
(defun my-css-mode-hook ()
  (rainbow-mode 1))


(provide 'emacs-rainbow-mode)
