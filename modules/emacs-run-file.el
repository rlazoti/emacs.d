(use-package exec-path-from-shell
  :ensure t
  :init
  (setq exec-path-from-shell-arguments nil)
  :config
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)))

(use-package quickrun
  :after exec-path-from-shell
  :config
  (setq quickrun-focus-p nil)
  :bind (:map global-map
              ("<f8>" . quickrun)
              ("<f7>" . quickrun-region)))

(customize-set-variable
 'display-buffer-alist
 '(("\\*quickrun\\*" display-buffer-below-selected)))

(provide 'emacs-run-file)
