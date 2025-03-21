(use-package magit)

(use-package magit-delta
  :ensure t
  :hook (magit-mode . magit-delta-mode))

(with-eval-after-load 'magit-delta
    (set-face-attribute 'magit-diff-added-highlight nil
              :background "#002800")
    (set-face-attribute 'magit-diff-added nil
              :background "#002800")
    (set-face-attribute 'magit-diff-removed-highlight nil
              :background "#3f0001")
    (set-face-attribute 'magit-diff-removed nil
              :background "#3f0001"))

(add-hook 'magit-delta-mode-hook
            (lambda ()
              (setq face-remapping-alist
                    (seq-difference face-remapping-alist
                                    '((magit-diff-removed . default)
                                      (magit-diff-removed-highlight . default)
                                      (magit-diff-added . default)
                                      (magit-diff-added-highlight . default))))))

(use-package browse-at-remote)
; (global-set-key (kbd "C-c g g") 'browse-at-remote)

(use-package git-link)

(setq ediff-window-setup-function 'ediff-setup-windows-plain)

;; (use-package forge
;;   :ensure t
;;   :after magit)

(provide 'emacs-git)
