(require 'flyspell)
(setq ispell-program-name "aspell" ; use aspell instead of ispell
      ispell-extra-args '("--sug-mode=ultra"))
(setq ispell-list-command "list")


(flyspell-mode +1)


(provide 'emacs-flyspell)
