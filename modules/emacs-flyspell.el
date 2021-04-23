(use-package abbrev
  :defer 1
  :ensure nil
  :custom
  (abbrev-file-name (expand-file-name ".abbrev_defs" user-emacs-directory))
  (abbrev-mode 1)
  :config
  (if (file-exists-p abbrev-file-name)
      (quietly-read-abbrev-file)))



(use-package flyspell
  :defer 1
  :hook ((markdown-mode org-mode text-mode) . flyspell-mode)
         (prog-mode . flyspell-prog-mode)
  :custom
  (flyspell-abbrev-p t)
  (flyspell-issue-message-flag nil)
  (flyspell-issue-welcome-flag nil)
  (flyspell-default-dictionary "en_US"))

(use-package flyspell-correct-ivy
  :after flyspell
  :bind (:map flyspell-mode-map
              ("C-;" . flyspell-correct-word-generic))
  :custom (flyspell-correct-interface 'flyspell-correct-ivy))

(provide 'emacs-flyspell)
