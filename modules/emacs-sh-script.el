(use-package sh-script
  :hook (after-save . executable-make-buffer-file-executable-if-script-p))

(provide 'emacs-sh-script)
