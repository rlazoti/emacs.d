(emacs-require-package 'highlight-symbol)

(require 'highlight-symbol)


(setq highlight-symbol-idle-delay 0.75)
(setq highlight-symbol-disable '())
(add-hook 'after-change-major-mode-hook
          (lambda ()
            (if (null (memql major-mode highlight-symbol-disable))
                (highlight-symbol-mode))))


(provide 'emacs-highlight-symbol)
