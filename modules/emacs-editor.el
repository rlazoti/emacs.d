(show-paren-mode 1)                   ;; enable highlighing matching delimiters


(setq-default indent-tabs-mode nil)   ;; don't use tabs to indent
(setq-default tab-width 2)            ;; but maintain correct appearance
(setq-default indent-tabs-mode nil)   ;; don't use tabs to indent
(setq-default tab-width 8)            ;; but maintain correct appearance


(cua-mode t)
(global-set-key (kbd "M-A") 'cua-set-rectangle-mark) ;; Global Key to start a vertical editing (MetaKey + Shift + a)
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


(provide 'emacs-editor)