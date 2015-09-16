(require 'flyspell)

(flyspell-mode +1)
(setq flyspell-issue-message-flg nil)

(add-hook 'enh-ruby-mode-hook
          (lambda () (flyspell-prog-mode)))

(add-hook 'web-mode-hook
          (lambda () (flyspell-prog-mode)))

(provide 'emacs-flyspell)
