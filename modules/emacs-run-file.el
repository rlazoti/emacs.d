(use-package exec-path-from-shell
  :init
  (setq exec-path-from-shell-arguments nil)
  :config
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)))

(use-package quickrun
  :after exec-path-from-shell
  :bind (:map global-map
              ("<f8>" . quickrun)
              ("<f7>" . quickrun-region)))

(provide 'emacs-run-file)
