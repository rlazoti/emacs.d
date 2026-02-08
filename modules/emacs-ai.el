(use-package vterm
  :defer t
  :config
  ;; Kill buffer when process exits
  (setq vterm-kill-buffer-on-exit t)
  ;; Increase scrollback
  (setq vterm-max-scrollback 10000))

(defun emacs-setenv-vterm (var value)
  (let* ((prefix (s-concat var "="))
         (new-value (s-concat prefix value))
         (without (-remove-first (lambda (v) (s-starts-with? prefix v)) vterm-environment)))
    (setq vterm-environment (cons new-value without))))

;; Required dependencies for claude-code-ide
(use-package websocket)
(use-package transient)
(use-package web-server)

(use-package claude-code-ide
  :vc (:url "https://github.com/manzaltu/claude-code-ide.el" :rev :newest)
  :bind ("C-c C-'" . claude-code-ide-menu)
  :config
  (require 'claude-code-ide-emacs-tools)
  (setq claude-code-ide-enable-mcp-server t)
  (setq claude-code-ide-cli-path "~/.bin/dcx")
  (claude-code-ide-emacs-tools-setup)
  ;; Disable line numbers in Claude buffers
  (add-hook 'vterm-mode-hook
            (lambda ()
              (when (string-match-p "^\\*claude-code\\[" (buffer-name))
                (display-line-numbers-mode -1)))))

;; (use-package copilot
;;   :vc (:url "https://github.com/copilot-emacs/copilot.el"
;;             :rev :newest
;;             :branch "main")
;;   :bind (("C-`" . copilot-accept-completion))
;;   :config
;;   (add-hook 'prog-mode-hook 'copilot-mode)
;;   (add-to-list 'copilot-major-mode-alist '("enh-ruby" . "ruby")))

(provide 'emacs-ai)
