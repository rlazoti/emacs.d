(emacs-require-packages '(multiple-cursors))


(require 'multiple-cursors)
(global-set-key (kbd "C-x <up>") 'mc/mark-previous-lines)
(global-set-key (kbd "C-x <down>") 'mc/mark-next-lines)
(global-set-key (kbd "C-x <left>") 'mc/mark-next-like-this)
(global-set-key (kbd "C-x <right>") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-x C-x") 'mc/mark-all-like-this)


(provide 'emacs-multiple-cursors)
