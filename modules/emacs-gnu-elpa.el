(use-package gnu-elpa-keyring-update
  :init
  (custom-set-variables '(epg-gpg-program  "/usr/local/bin/gpg"))
  :config
  (gnu-elpa-keyring-update))

(provide 'emacs-gnu-elpa)
