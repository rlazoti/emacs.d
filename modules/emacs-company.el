(use-package company
  :ensure t
  :hook (after-init . global-company-mode)
  :config
  (setq company-tooltip-width-grow-only t))

;; (use-package company-quickhelp
;;   :ensure t
;;    :after company
;;    :hook (after-init . company-quickhelp-mode))

(provide 'emacs-company)
