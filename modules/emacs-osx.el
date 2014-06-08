(set-default-font "Monaco 14")


;; use command as meta key
(setq mac-option-modifier 'super)
(setq mac-command-modifier 'meta)


;; hach to use option-click as mouse-2 click
;; (require 'emacs-osx)
(custom-set-variables
 '(mac-emulate-three-button-mouse t))


;;add-hook 'term-setup-hook
;; '(lambda ()
;;    (define-key function-key-map "\e[1;9A" [M-up])
;;    (define-key function-key-map "\e[1;9B" [M-down])
;;    (define-key function-key-map "\e[1;9C" [M-right])
;;    (define-key function-key-map "\e[1;9D" [M-left])))

(provide 'emacs-osx)
