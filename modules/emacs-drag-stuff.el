(emacs-require-package 'drag-stuff)

(drag-stuff-global-mode 1)
(global-set-key (kbd "M-<up>") 'drag-stuff-up)
(global-set-key (kbd "M-<down>") 'drag-stuff-down)

(provide 'emacs-drag-stuff)
