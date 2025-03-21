(use-package blamer
  :custom
  (blamer-idle-time 2)
  (blamer-min-offset 70)
  (blamer-type 'visual)
  :custom-face
  (blamer-face ((t :foreground "#787BE5"
                   :background unspecified
                   :height 140
                   :italic t)))
  :config
  (defun blamer-callback-show-commit-diff (commit-info)
    (interactive)
    (let ((commit-hash (plist-get commit-info :commit-hash)))
      (when commit-hash
        (magit-show-commit commit-hash))))

  (defun blamer-callback-open-remote (commit-info)
    (interactive)
    (let ((commit-hash (plist-get commit-info :commit-hash)))
      (when commit-hash
        (interactive)
        (message commit-hash)
        (browse-url (browse-at-remote--commit-url commit-hash)))))

  (setq blamer-bindings '(("<mouse-3>" . blamer-callback-open-remote)
                          ("<mouse-1>" . blamer-callback-show-commit-diff)))

  (global-blamer-mode 1)
  )

(provide 'emacs-blamer)
