(emacs-require-packages '(helm))


(helm-mode 1)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-c C-f") 'helm-do-grep)


(provide 'emacs-helm)
