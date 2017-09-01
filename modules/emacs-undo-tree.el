(emacs-require-package 'undo-tree)

(global-undo-tree-mode)
(global-set-key (kbd "s-/") 'undo-tree-visualize)

(provide 'emacs-undo-tree)
