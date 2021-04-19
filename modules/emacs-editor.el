(use-package editorconfig
  :ensure t
  :config
  (editorconfig-mode 1))

(require 'windmove)
(require 'whitespace)

(add-hook 'editorconfig-custom-hooks
          (lambda (hash) (setq web-mode-block-padding 0)))

(setq-default highlight-tabs t)
(setq-default indent-line-function 2)
(setq-default indicate-empty-lines t)
(setq-default ispell-program-name "aspell")
(setq-default show-trailing-whitespace t)
(setq-default tab-width 2)

(setq buffer-file-coding-system 'utf-8-unix)
(setq column-number-mode t)
(setq default-buffer-file-coding-system 'utf-8)
(setq default-file-name-coding-system 'utf-8-unix)
(setq default-input-method 'portuguese-prefix)
(setq default-keyboard-coding-system 'utf-8-unix)
(setq default-process-coding-system '(utf-8-unix . utf-8-unix))
(setq default-sendmail-coding-system 'utf-8-unix)
(setq default-terminal-coding-system 'utf-8-unix)
(setq indent-tabs-mode nil)
(setq locale-coding-system 'utf-8)
(setq ns-right-alternate-modifier nil) ; disable right alt key so I can use PT-br accented chars
(setq save-interprogram-paste-before-kill t)
(setq tab-always-indent 'complete)
(setq tab-width 2)
(setq whitespace-line-column 100)
(setq whitespace-style (quote (spaces tabs space-mark tab-mark newline-mark trailing lines-tail)))
(setq x-select-enable-clipboard t)
(setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))

;; store all backup and autosave files in the tmp dir
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

(set-default-coding-systems 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-language-environment 'UTF-8)
(set-selection-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)

(prefer-coding-system 'utf-8)

;; fix upcase-region and downcase-region, they're disabled by default
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)

(global-set-key (kbd "C-+")         'text-scale-increase)
(global-set-key (kbd "C--")         'text-scale-decrease)
(global-set-key (kbd "C-l")         'goto-line)
(global-set-key (kbd "C-c a")       'align-regexp)
(global-set-key (kbd "C-c r")       'replace-string)
(global-set-key (kbd "C-c <left>")  'windmove-left)
(global-set-key (kbd "C-c <right>") 'windmove-right)
(global-set-key (kbd "C-c <up>")    'windmove-up)
(global-set-key (kbd "C-c <down>")  'windmove-down)
(global-set-key (kbd "M-U")         'upcase-region)
(global-set-key (kbd "M-L")         'downcase-region)
(global-set-key (kbd "M-C")         'capitalize-region)
(global-set-key (kbd "M-u")         'upcase-word)
(global-set-key (kbd "M-l")         'downcase-word)
(global-set-key (kbd "M-c")         'capitalize-word)

(show-paren-mode t)
(blink-cursor-mode t)
(global-auto-revert-mode t)
(global-hl-line-mode +1)
(delete-selection-mode t)
(global-display-line-numbers-mode t)

;; disable line numbers for some modes
(dolist (mode '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                neotree-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; do a search using the selected text
(defadvice isearch-mode (around isearch-mode-default-string (forward &optional regexp op-fun recursive-edit word-p) activate)
  (if (and transient-mark-mode mark-active (not (eq (mark) (point))))
      (progn
        (isearch-update-ring (buffer-substring-no-properties (mark) (point)))
        (deactivate-mark)
        ad-do-it
        (if (not forward)
            (isearch-repeat-backward)
          (goto-char (mark))
          (isearch-repeat-forward)))
    ad-do-it))

(provide 'emacs-editor)
