(emacs-require-packages '(company company-quickhelp company-web))

(require 'company)
(require 'company-web-html)

(setq company-echo-delay 0)
(setq company-idle-delay 0.3)
(setq company-tooltip-limit 20)
(setq company-auto-complete nil)
(setq company-dabbrev-downcase nil)
(setq company-minimum-prefix-length 2)
(setq company-tooltip-align-annotations 't) 

(add-to-list 'company-backends 'company-elisp t)
(add-to-list 'company-backends 'company-yasnippet t)
(setq company-backends (remove 'company-eclim company-backends))

(add-hook 'after-init-hook 'global-company-mode)
(company-quickhelp-mode 1)

(provide 'emacs-company-mode)
