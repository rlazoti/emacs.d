(set-default-font "Monaco 14")

;; use command as meta key
(setq mac-option-modifier 'super)
(setq mac-command-modifier 'meta)

;; hach to use option-click as mouse-2 click
;; (require 'emacs-osx)
(custom-set-variables
 '(mac-emulate-three-button-mouse t))

(provide 'emacs-osx)
