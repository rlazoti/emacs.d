(emacs-require-packages '(company company-quickhelp company-web))

(require 'company)
(require 'company-web-html)

(setq company-echo-delay 0)
(setq company-idle-delay 0.2)
(setq company-tooltip-limit 20)
(setq company-auto-complete nil)
(setq company-dabbrev-downcase nil)
(setq company-minimum-prefix-length 2)

(custom-set-faces
 '(company-tooltip ((t (:background "lightgray" :foreground "black"))))
 '(company-tooltip-annotation ((t (:background "lightgray" :foreground "black"))))

 '(company-tooltip-selection ((t (:background "steelblue" :foreground "white"))))
 '(company-tooltip-annotation-selection ((t (:background "steelblue" :foreground "white"))))
 
 '(company-scrollbar-fg ((t (:background "darkred" :foreground "darkred"))))
 '(company-scrollbar-bg ((t (:background "lightgray" :foreground "lightgray"))))
 
 '(company-preview ((t (:foreground "darkgray" :underline t))))
 '(company-preview-common ((t (:inherit company-preview))))

 '(company-tooltip-common
   ((((type x)) (:inherit company-tooltip :weight bold))
    (t (:inherit company-tooltip))))

 '(company-tooltip-common-selection
   ((((type x)) (:inherit company-tooltip-selection :weight bold))
    (t (:inherit company-tooltip-selection))))
)

(add-to-list 'company-backends 'company-elisp t)
(add-to-list 'company-backends 'company-yasnippet t)
(setq company-backends (remove 'company-eclim company-backends))

(add-hook 'after-init-hook 'global-company-mode)
(company-quickhelp-mode 1)

(provide 'emacs-company-mode)
