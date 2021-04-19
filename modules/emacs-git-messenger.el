(emacs-require-package 'git-messenger)

(global-set-key (kbd "C-x v p") 'git-messenger:popup-message)

;;(define-key git-messenger-map (kbd "m") 'git-messenger:copy-message)

(custom-set-variables
 '(git-messenger:use-magit-popup t))

(provide 'emacs-git-messenger)
