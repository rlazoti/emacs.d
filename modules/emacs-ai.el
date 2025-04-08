(use-package vterm)

(defun emacs-setenv-vterm (var value)
  (let* ((prefix (s-concat var "="))
         (new-value (s-concat prefix value))
         (without (-remove-first (lambda (v) (s-starts-with? prefix v)) vterm-environment)))
    (setq vterm-environment (cons new-value without))))

(defun emacs-aidermacs-before-run ()
  (emacs-setenv-vterm "OPENAI_API_KEY" (emacs-openai-api-key)))

(use-package aidermacs
  :bind (("C-c q" . aidermacs-transient-menu))
  :init
  (add-hook 'aidermacs-before-run-backend-hook #'emacs-aidermacs-before-run)
  :config
  (setq aidermacs-extra-args '("--config" "~/.aider/aider.conf.yml"))
  (setq aidermacs-backend 'vterm)
  (setq aidermacs-show-diff-after-change nil)
  (setq aidermacs-vterm-multiline-newline-key "S-<return>"))

(use-package gptel
  :bind (("C-c w" . gptel-menu))
  :config
  (setq gptel-api-key #'emacs-openai-api-key)
  (setq gptel-log-level 'debug)
  (setq gptel-use-curl t)
  (setq gptel--openai-models nil)
  (setq-default gptel-backend shopify-gptel
                gptel-model   'anthropic:claude-3-7-sonnet-20250219))

(provide 'emacs-ai)
