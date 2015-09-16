(emacs-require-packages '(wgrep wgrep-ag))

(global-set-key (kbd "C-S-r") 'wgrep-change-to-wgrep-mode)

(provide 'emacs-wgrep)
