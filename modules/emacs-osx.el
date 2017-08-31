(set-default-font "Monaco 12")

;; use command as meta key
(setq mac-option-modifier 'super)
(setq mac-command-modifier 'meta)

;; macOS command ls doesn't support --dired option
(setq dired-use-ls-dired nil)

;; hach to use option-click as mouse-2 click
;; (require 'emacs-osx)
(custom-set-variables
 '(mac-emulate-three-button-mouse t))

(provide 'emacs-osx)
