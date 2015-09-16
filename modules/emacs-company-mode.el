(emacs-require-packages '(company company-inf-ruby))

(require 'company)

(add-hook 'after-init-hook 'global-company-mode)
(setq company-idle-delay 0.3)
(setq company-tooltip-limit 20)
(setq company-minimum-prefix-length 2)
(setq company-echo-delay 0)
(setq company-auto-complete nil)
(add-to-list 'company-backends 'company-dabbrev t)
(add-to-list 'company-backends 'company-ispell t)
(add-to-list 'company-backends 'company-files t)
(setq company-backends (remove 'company-ropemacs company-backends))

(provide 'emacs-company-mode)
