(require 'hideshow)

(global-set-key (kbd "C-'") 'hs-toggle-hiding)
(global-set-key (kbd "M-_") 'hs-hide-all)
(global-set-key (kbd "M-+") 'hs-show-all)

(add-hook 'prog-mode-hook #'hs-minor-mode)

(provide 'emacs-hideshow)
