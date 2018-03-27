(set-default-font "Monaco 12")

;; set keys for Apple keyboard, for emacs in OS X
(setq mac-command-modifier 'super)
(setq mac-option-modifier 'meta)

(setq mac-control-modifier 'control)
(setq ns-function-modifier 'hyper)

;; macOS command ls doesn't support --dired option
(setq dired-use-ls-dired nil)

;; hach to use option-click as mouse-2 click
;; (require 'emacs-osx)
(custom-set-variables
 '(mac-emulate-three-button-mouse t))

(provide 'emacs-osx)
