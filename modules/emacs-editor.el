(use-package editorconfig
  :config
  (editorconfig-mode 1))

(use-package goto-line-preview
  :config
  (global-set-key [remap goto-line] 'goto-line-preview))

(use-package string-inflection
  :defer t)
(global-unset-key (kbd "C-q"))
(global-set-key (kbd "C-q C-u") 'my-string-inflection-cycle-auto)

(defun my-string-inflection-cycle-auto ()
  "Switching by major-mode."
  (interactive)
  (cond
   ((eq major-mode 'emacs-lisp-mode)
    (string-inflection-all-cycle))
   ((eq major-mode 'python-mode)
    (string-inflection-python-style-cycle))
   ((eq major-mode 'java-mode)
    (string-inflection-java-style-cycle))
   (t
    (string-inflection-ruby-style-cycle))))

;; (use-package super-save
;;   :ensure t
;;   :config
;;   (super-save-mode +1))

(require 'windmove)

(add-hook 'editorconfig-custom-hooks
          (lambda (hash) (setq web-mode-block-padding 0)))

(setq-default cursor-in-non-selected-windows t)
(setq-default display-line-numbers-widen t)
(setq-default display-line-numbers-width 3)
(setq-default fringes-outside-margins t)
(setq-default highlight-tabs t)
(setq-default indent-line-function 2)
(setq-default indent-tabs-mode nil)
(setq-default ispell-program-name "aspell")
(setq-default tab-width 2)
(setq-default vc-follow-symlinks t)
(setq-default view-read-only t)
(setq-default word-wrap t)

(setq buffer-file-coding-system 'utf-8-unix)
(setq column-number-mode t)
(setq default-file-name-coding-system 'utf-8-unix)
(setq default-input-method 'portuguese-prefix)
(setq default-keyboard-coding-system 'utf-8-unix)
(setq default-process-coding-system '(utf-8-unix . utf-8-unix))
(setq default-sendmail-coding-system 'utf-8-unix)
(setq default-terminal-coding-system 'utf-8-unix)
(setq indicate-buffer-boundaries nil)
(setq indicate-empty-lines nil)
(setq locale-coding-system 'utf-8)
(setq ns-right-alternate-modifier nil) ; disable right alt key so I can use PT-br accented chars
(setq require-final-newline t)
(setq save-interprogram-paste-before-kill t)
(setq tab-always-indent 'indent)
(setq tab-width 2)
(setq select-enable-clipboard t)
(setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))
(setq isearch-lazy-count t)

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

(defun next-code-buffer ()
  (interactive)
  (let (( bread-crumb (buffer-name) ))
    (next-buffer)
    (while
        (and
         (string-match-p "^\*" (buffer-name))
         (not ( equal bread-crumb (buffer-name) )) )
      (next-buffer))))

(defun previous-code-buffer ()
  (interactive)
  (let (( bread-crumb (buffer-name) ))
    (previous-buffer)
    (while
        (and
         (string-match-p "^\*" (buffer-name))
         (not ( equal bread-crumb (buffer-name) )) )
      (previous-buffer))))

(global-set-key [remap next-buffer]     'next-code-buffer)
(global-set-key [remap previous-buffer] 'previous-code-buffer)
(global-set-key (kbd "C-+")             'text-scale-increase)
(global-set-key (kbd "C--")             'text-scale-decrease)
(global-set-key (kbd "C-l")             'goto-line)
(global-set-key (kbd "C-c a")           'align-regexp)
(global-set-key (kbd "C-c r")           'replace-string)
(global-set-key (kbd "C-c <left>")      'windmove-left)
(global-set-key (kbd "C-c <right>")     'windmove-right)
(global-set-key (kbd "C-c <up>")        'windmove-up)
(global-set-key (kbd "C-c <down>")      'windmove-down)
(global-set-key (kbd "M-U")             'upcase-region)
(global-set-key (kbd "M-L")             'downcase-region)
(global-set-key (kbd "M-C")             'capitalize-region)
(global-set-key (kbd "M-u")             'upcase-word)
(global-set-key (kbd "M-l")             'downcase-word)
(global-set-key (kbd "M-c")             'capitalize-word)

(blink-cursor-mode t)
(delete-selection-mode t)
(fringe-mode '10)
(global-auto-revert-mode t)
(global-display-line-numbers-mode t)
(global-hl-line-mode +1)
(show-paren-mode t)
(size-indication-mode t)
;; (normal-erase-is-backspace-mode t)

;; disable line numbers for some modes
(dolist (mode '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                neotree-mode-hook
                treemacs-mode-hook
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

;; send formatted code to system clipboard
;; it has an external dependency: brew install pygments
(defun formatted-copy (lang &optional b e)
  "Export region to RTF, and copy it to the clipboard."
  (interactive "sLanguage: \nr")
  (shell-command-on-region
   b e (format "pygmentize -l %s -f rtf -O style=solarized-light | pbcopy" lang)))

(provide 'emacs-editor)
