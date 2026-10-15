;;; rl-theme.el --- Colours -*- lexical-binding: t; -*-
;;; Commentary:
;; Ported from the old modules/emacs-theme.el.
;; `doom-themes-treemacs-config' is not used: it depends on all-the-icons.
;; Treemacs icons come from `treemacs-nerd-icons' (see rl-projects.el).

;;; Code:

(use-package doom-themes
  :custom
  (doom-themes-enable-bold t)
  (doom-themes-enable-italic t)
  :config
  (load-theme 'doom-one t)
  ;; Flash the mode line instead of beeping on error.
  (doom-themes-visual-bell-config)
  ;; Better font locking of org-mode source blocks and tables.
  (doom-themes-org-config))

(provide 'rl-theme)
;;; rl-theme.el ends here
