(emacs-require-packages '(js2-mode json-mode))

(add-to-list 'auto-mode-alist '("\\.jsx?\\'" . js2-jsx-mode))
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))

(add-hook 'json-mode 'flymake-json-load)

(add-hook 'js2-mode-hook 'company-mode)
(add-hook 'js2-mode-hook 'flymake-mode)
(add-hook 'js2-mode-hook 'flymake-jslint-load)

(add-hook 'js2-mode-hook (lambda ()
                          (setq js2-basic-offset 2)
                          (setq js-indent-level 2)
                          (setq js2-highlight-level 3)
                          (setq js2-bounce-indent-p t)
                          (local-set-key (kbd "RET") 'newline-and-indent)))

(provide 'emacs-javascript)
