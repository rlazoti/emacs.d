(use-package terraform-mode)

(use-package company-terraform
  :after (company terraform-mode)
  :init (company-terraform-init))

(provide 'emacs-terraform)
