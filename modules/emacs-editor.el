;; enable highlighing matching delimiters
(show-paren-mode t)


;; Highlight tabulations
(setq-default highlight-tabs t)


;; Show trailing white spaces
(setq-default show-trailing-whitespace t)


;; disable tool bar / menu bar
(if (functionp 'menu-bar-mode) (menu-bar-mode -1))
(if (functionp 'tool-bar-mode) (tool-bar-mode -1))


;; define aspell as default spelling checker
(setq-default ispell-program-name "aspell")


;; define accented chars
;; set up unicode
;; keyboard / input method settings
(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(set-language-environment 'UTF-8) ; prefer utf-8 for language settings
(set-default-coding-systems 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)
(setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))
(prefer-coding-system       'utf-8)
(setq buffer-file-coding-system 'utf-8-unix)
(setq default-file-name-coding-system 'utf-8-unix)
(setq default-keyboard-coding-system 'utf-8-unix)
(setq default-process-coding-system '(utf-8-unix . utf-8-unix))
(setq default-sendmail-coding-system 'utf-8-unix)
(setq default-terminal-coding-system 'utf-8-unix)
(setq default-input-method 'portuguese-prefix)


; Use the system clipboard
(setq x-select-enable-clipboard t)


;; fix upcase-region and downcase-region, they're disabled by default
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)


;; Font size
(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)


;; Go to line number
(global-set-key (kbd "C-l") 'goto-line)


;; Align a region by a regex
(global-set-key (kbd "C-c a") 'align-regexp)


;; Replace String
(global-set-key (kbd "C-c r") 'replace-string)


;; use shift + arrow keys to switch between visible buffers
(require 'windmove)
(global-set-key (kbd "C-c <left>")  'windmove-left)
(global-set-key (kbd "C-c <right>") 'windmove-right)
(global-set-key (kbd "C-c <up>")    'windmove-up)
(global-set-key (kbd "C-c <down>")  'windmove-down)


;; capitalize or change case of words and regions
(global-set-key (kbd "M-U") 'upcase-region)
(global-set-key (kbd "M-L") 'downcase-region)
(global-set-key (kbd "M-C") 'capitalize-region)
(global-set-key (kbd "M-u") 'upcase-word)
(global-set-key (kbd "M-l") 'downcase-word)
(global-set-key (kbd "M-c") 'capitalize-word)


;; whitespace-mode config
(require 'whitespace)
(setq whitespace-line-column 120) ;; limit line length
(setq whitespace-style (quote (spaces tabs space-mark tab-mark newline-mark trailing lines-tail)))


(setq indent-tabs-mode nil)   ;; don't use tabs to indent
(setq tab-width 2)            ;; but maintain correct appearance


(global-auto-revert-mode t)           ;; revert buffers automatically when underlying files are changed externally
(global-hl-line-mode +1)              ;; highlight the current line


(delete-selection-mode t)             ;; delete the selection with a keypress


(setq tab-always-indent 'complete)    ;; smart tab behavior - indent or complete


;; store all backup and autosave files in the tmp dir
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))


;; display the line number, total lines and column line
(defvar my-mode-line-buffer-line-count nil)
(make-variable-buffer-local 'my-mode-line-buffer-line-count)

(setq-default mode-line-format
	'("  " mode-line-modified
    (list 'line-number-mode "  ")
    (:eval (when line-number-mode
       (let ((str "Line %l"))
	 (when (and (not (buffer-modified-p)) my-mode-line-buffer-line-count)
	   (setq str (concat str " of " my-mode-line-buffer-line-count)))
	 str)))
    "  %p"
    (list 'column-number-mode "  Column %c")
    "  " mode-line-buffer-identification
    "  " mode-line-modes))

(defun my-mode-line-count-lines ()
  (setq my-mode-line-buffer-line-count (int-to-string (count-lines (point-min) (point-max)))))

(add-hook 'find-file-hook 'my-mode-line-count-lines)
(add-hook 'after-save-hook 'my-mode-line-count-lines)
(add-hook 'after-revert-hook 'my-mode-line-count-lines)
(add-hook 'dired-after-readin-hook 'my-mode-line-count-lines)


;; Searching for marked (selected) text
(defun search-selection (beg end)
  "search for selected text"
  (interactive "r")
  (let (
  (selection (buffer-substring-no-properties beg end))
  )
    (deactivate-mark)
    (isearch-mode t nil nil nil)
    (isearch-yank-string selection)
    )
  )
(define-key global-map (kbd "C-c C-s") 'search-selection)


(provide 'emacs-editor)
