;;; rl-web.el --- HTML, ERB, Svelte, CSS -*- lexical-binding: t; -*-
;;; Commentary:
;; Ported from the old modules/emacs-web.el.
;;
;; Not ported:
;; - counsel-css (needs Ivy; `imenu' and `consult-imenu' do the same job in
;;   CSS buffers)
;; - company-web (the completion stack is now corfu + cape)

;;; Code:

(use-package web-mode
  :mode ("\\.[px]?html?\\'"
         "\\.\\(?:tpl\\|blade\\)\\(?:\\.php\\)?\\'"
         "\\.erb\\'"
         "\\.l?eex\\'"
         "\\.jsp\\'"
         "\\.as[cp]x\\'"
         "\\.hbs\\'"
         "\\.mustache\\'"
         "\\.svelte\\'"
         "\\.twig\\'"
         "\\.jinja2?\\'"
         "\\.eco\\'"
         "wp-content/themes/.+/.+\\.php\\'"
         "templates/.+\\.php\\'")
  :custom
  (web-mode-markup-indent-offset 2)
  (web-mode-css-indent-offset 2)
  (web-mode-code-indent-offset 2)
  (web-mode-block-padding 0)
  (web-mode-enable-current-element-highlight t)
  (web-mode-enable-current-column-highlight t))

(use-package emmet-mode
  :after web-mode
  :hook (sgml-mode web-mode css-mode))

(use-package css-mode
  :ensure nil
  :custom (css-indent-offset 2))

(use-package less-css-mode
  :ensure nil
  :mode "\\.less\\'")

(use-package scss-mode
  :mode "\\.scss\\'"
  :custom (scss-compile-at-save nil)
  :preface
  ;; scss-mode's last release (2018) still uses the legacy flymake API: it pushes
  ;; onto `flymake-allowed-file-name-masks' and `flymake-err-line-patterns'.  The
  ;; flymake built into Emacs 31 no longer defines the first, so loading the
  ;; package used to fail halfway through.  Declaring them first makes those
  ;; pushes harmless; SCSS checking comes from flycheck.
  (defvar flymake-allowed-file-name-masks nil
    "Legacy variable kept defined so old packages still load.")
  (defvar flymake-err-line-patterns nil
    "Legacy variable kept defined so old packages still load."))

(provide 'rl-web)
;;; rl-web.el ends here
