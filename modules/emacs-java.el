(emacs-require-package 'malabar-mode)


(setq semantic-default-submodes '(global-semantic-idle-scheduler-mode
                                  global-semanticdb-minor-mode
                                  global-semantic-idle-summary-mode
                                  global-semantic-mru-bookmark-mode))
(semantic-mode 1)
(require 'malabar-mode)
(add-to-list 'auto-mode-alist '("\\.java\\'" . malabar-mode))
(setq-default tab-width 2)

;; add emsime shortcuts ;)
(define-key global-map (kbd "C-c C-r t") 'malabar-import-one-class)
(define-key global-map (kbd "C-c C-r a") 'malabar-import-all)
(define-key global-map (kbd "C-c C-v t") 'malabar-run-test)
(define-key global-map (kbd "C-c C-v u") 'malabar-update-package)
(define-key global-map (kbd "M-.") 'malabar-jump-to-thing)

(provide 'emacs-java)
