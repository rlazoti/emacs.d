(use-package aidermacs
  :bind (("C-c q" . aidermacs-transient-menu))

  :config
  (setq aidermacs-extra-args '("--config" "~/.aider/.aider.conf.yml"))
  (setq aidermacs-backend 'vterm)
  (setq aidermacs-vterm-multiline-newline-key "S-<return>")
  (setq aidermacs-show-diff-after-change nil)

  :custom
  (aidermacs-use-architect-mode t))

(provide 'emacs-aidermacs)
