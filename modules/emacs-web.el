(use-package web-mode
  :mode "\\.[px]?html?\\'"
  :mode "\\.\\(?:tpl\\|blade\\)\\(?:\\.php\\)?\\'"
  :mode "\\.erb\\'"
  :mode "\\.l?eex\\'"
  :mode "\\.jsp\\'"
  :mode "\\.as[cp]x\\'"
  :mode "\\.hbs\\'"
  :mode "\\.mustache\\'"
  :mode "\\.svelte\\'"
  :mode "\\.twig\\'"
  :mode "\\.jinja2?\\'"
  :mode "\\.eco\\'"
  :mode "wp-content/themes/.+/.+\\.php\\'"
  :mode "templates/.+\\.php\\'"
  :config
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-enable-current-element-highlight t)
  (setq web-mode-code-indent-offset 2))

(use-package emmet-mode
  :delight
  :hook (css-mode sgml-mode web-mode))

(use-package company-web
  :after (company web-mode))

(use-package counsel-css
  :hook (css-mode . counsel-css-imenu-setup))

(use-package css-mode
  :custom (css-indent-offset 2))

(use-package less-css-mode
  :mode "\\.less\\'")

(use-package scss-mode
  :mode "\\.scss\\'")

(provide 'emacs-web)
