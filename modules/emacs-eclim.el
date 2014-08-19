(emacs-require-package 'emacs-eclim)

(require 'eclim)
(global-eclim-mode)
(require 'eclimd)


;; Eclipse installation
(custom-set-variables
  '(eclim-eclipse-dirs '("~/Programs/eclipse-eclim"))
  '(eclim-executable "~/Programs/eclipse-eclim/eclim"))


;; Displaying compilation error messages in the echo area
(setq help-at-pt-display-when-idle t)
(setq help-at-pt-timer-delay 0.1)
(help-at-pt-set-timer)


;; add the emacs-eclim source
(require 'ac-emacs-eclim-source)
(ac-emacs-eclim-config)


(provide 'emacs-eclim)
