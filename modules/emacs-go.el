(emacs-require-packages '(go-mode company-go))

(add-hook 'go-mode-hook (lambda ()
                          (set (make-local-variable 'company-backends) '(company-go))
                          (company-mode)))

(provide 'emacs-go)
