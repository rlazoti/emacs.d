(emacs-require-package 'move-text)


(require 'move-text)
(global-set-key (kbd "M-<down>") 'move-text-down)
(global-set-key (kbd "M-<up>") 'move-text-up)

(provide 'emacs-move-text)
