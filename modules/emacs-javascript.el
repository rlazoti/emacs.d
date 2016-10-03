(emacs-require-packages '(js2-mode json-mode))

(add-to-list 'auto-mode-alist '("\\.jsx?\\'" . js2-jsx-mode))
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))

(setq js2-indent-level 2
      js2-basic-offset 2
      js2-highlight-level 3)

(add-hook 'json-mode 'flymake-json-load)
(add-hook 'js2-mode-hook 'flymake-jslint-load)
(add-hook 'js2-mode-hook 'flymake-mode)
(add-hook 'js2-mode-hook 'company-mode)
(add-hook 'js2-mode-hook '(lambda ()
                            (local-set-key (kbd "RET") 'newline-and-indent)))

(provide 'emacs-javascript)
