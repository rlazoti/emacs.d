(emacs-require-package 'emacs-eclim)

(require 'eclim)
(global-eclim-mode)
(require 'eclimd)

;; Eclipse installation
(custom-set-variables
  '(eclim-eclipse-dirs '("~/Programs/eclipse-eclim"))
  '(eclim-executable "~/Programs/eclipse-eclim/eclim")
	'(eclimd-default-workspace "~/Programs/eclim-workspace"))

;; Displaying compilation error messages in the echo area
(setq help-at-pt-display-when-idle t)
(setq help-at-pt-timer-delay 0.1)
(help-at-pt-set-timer)

;; Configuring company-mode
(require 'company)
(require 'company-emacs-eclim)
(company-emacs-eclim-setup)
(global-company-mode t)

;; Eclim key bindings
(global-set-key (kbd "C-c C-f") 'eclim-java-find-declaration)
(global-set-key (kbd "C-c C-g") 'eclim-java-find-references)
(global-set-key (kbd "C-c C-r") 'eclim-java-refactor-rename-symbol-at-point)
(global-set-key (kbd "C-c C-d") 'eclim-java-show-documentation-for-current-element)
(global-set-key (kbd "C-c C-v") 'eclim-java-hierarchy)
(global-set-key (kbd "C-c C-o") 'eclim-java-import-organize)
(global-set-key (kbd "C-c C-e") 'eclim-problems-correct)
(global-set-key (kbd "C-c m") 'eclim-maven-run)



(provide 'emacs-eclim)
