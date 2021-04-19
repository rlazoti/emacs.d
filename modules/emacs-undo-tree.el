(use-package undo-tree
  :ensure t
	:init
	(global-undo-tree-mode)
	:bind
  (:map global-map
				("s-/" . undo-tree-visualize)))

(provide 'emacs-undo-tree)
