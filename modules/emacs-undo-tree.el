(use-package undo-tree
  :config
  (global-undo-tree-mode 1)
  (setq undo-tree-visualizer-diff 1)
  (setq undo-tree-visualizer-timestamps 1)

  :bind (:map global-map
              ("s-/" . undo-tree-visualize)))

(provide 'emacs-undo-tree)
