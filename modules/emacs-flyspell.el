(require 'flyspell)


;;(setq ispell-program-name "aspell" ; use aspell instead of ispell
;;      ispell-extra-args '("--sug-mode=ultra"))
;;(setq ispell-list-command "list")
;;(flyspell-mode +1)


(require 'flyspell)


(setq flyspell-issue-message-flg nil)
(add-hook 'enh-ruby-mode-hook
          (lambda () (flyspell-prog-mode)))


(add-hook 'web-mode-hook
          (lambda () (flyspell-prog-mode)))


;; flyspell mode breaks auto-complete mode without this.
(ac-flyspell-workaround)


(provide 'emacs-flyspell)
