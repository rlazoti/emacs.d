(emacs-require-package 'highlight-symbol)

(require 'highlight-symbol)

(setq highlight-symbol-idle-delay 0.50)
(setq highlight-symbol-disable '(help-mode))
(add-hook 'after-change-major-mode-hook
          (lambda ()
            (if (null (memql major-mode highlight-symbol-disable))
                (highlight-symbol-mode))))

(global-set-key (kbd "M-n") 'highlight-symbol-next)
(global-set-key (kbd "M-p") 'highlight-symbol-prev)
(global-set-key (kbd "M-N") 'highlight-symbol-query-replace)

(provide 'emacs-highlight-symbol)
