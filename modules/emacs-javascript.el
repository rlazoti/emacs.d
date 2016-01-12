(emacs-require-packages '(js2-mode grunt json-mode))

(require 'grunt)

(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
(add-to-list 'auto-mode-alist '("\\.json$" . js2-mode))

(setq js-indent-level 2
      js2-indent-level 2
      js2-basic-offset 2
      js2-highlight-level 3)

(setq ac-js2-evaluate-calls t)

(add-hook 'js2-mode-hook 'flymake-mode)
(add-hook 'js2-mode-hook 'company-mode)
(add-hook 'js2-mode-hook '(lambda ()
                            (local-set-key (kbd "RET") 'newline-and-indent)))

(provide 'emacs-javascript)
