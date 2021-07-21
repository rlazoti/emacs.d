(add-to-list 'auto-mode-alist '("\\.js\\'" . js-mode))
(add-to-list 'auto-mode-alist '("\\.jsx\\'" . js-mode))

(use-package js2-mode
  :config (add-hook 'js-mode-hook 'js2-minor-mode)
)

(provide 'emacs-javascript)
