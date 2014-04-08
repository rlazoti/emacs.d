(emacs-require-packages '(auto-complete popup))

(require 'auto-complete)
(require 'auto-complete-config)

(ac-config-default)

(ac-set-trigger-key "TAB")
(global-auto-complete-mode t)
(setq ac-auto-show-menu t)
(setq ac-dwim t)
(setq ac-use-menu-map t)
(setq ac-quick-help-delay 1)
(setq ac-quick-help-height 60)

(provide 'emacs-autocomplete)
