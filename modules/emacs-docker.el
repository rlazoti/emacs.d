(emacs-require-packages '(dockerfile-mode docker-compose-mode))

(require 'dockerfile-mode)
(add-to-list 'auto-mode-alist '("Dockerfile\\'" . dockerfile-mode))

(require 'docker-compose-mode)

(provide 'emacs-docker)
