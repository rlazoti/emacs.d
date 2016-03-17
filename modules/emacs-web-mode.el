(emacs-require-packages '(web-mode web-beautify))

(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.jsp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.css?\\'" . css-mode))
(add-to-list 'auto-mode-alist '("\\.scss?\\'" . css-mode))

(defun my-web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (set-face-attribute 'web-mode-css-rule-face nil :foreground "Pink3")
  (local-set-key (kbd "RET") 'newline-and-indent))

(add-hook 'web-mode-hook 'my-web-mode-hook)

(eval-after-load 'css-mode
  '(define-key css-mode-map (kbd "C-c b") 'web-beautify-css))

(provide 'emacs-web-mode)
