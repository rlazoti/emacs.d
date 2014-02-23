;; define melpa repository
(when (>= emacs-major-version 24)
  (require 'package)
  (package-initialize)
  (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
  )


;; define custom variables by emacs menu
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(custom-enabled-themes (quote (monokai)))
 '(custom-safe-themes (quote ("73fe242ddbaf2b985689e6ec12e29fab2ecd59f765453ad0e93bc502e6e478d6" default)))
 '(menu-bar-mode nil)
 '(show-paren-mode t)
 '(size-indication-mode t)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;; define default mode for js extesion
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))


;; load the ensime lisp code...
(add-to-list 'load-path "/Users/rodrigolazoti/Programs/ensime_2.10.0-0.9.8.9/elisp/")
(require 'ensime)


;; This step causes the ensime-mode to be started whenever
;; scala-mode is started for a buffer. You may have to customize this step
;; if you're not using the standard scala mode.
(add-hook 'scala-mode-hook 'ensime-scala-mode-hook)


;; define a global key for (un)comment a region or a line
(defun comment-or-uncomment-region-or-line ()
    "Comments or uncomments the region or the current line if there's no active region."
    (interactive)
    (let (beg end)
        (if (region-active-p)
            (setq beg (region-beginning) end (region-end))
            (setq beg (line-beginning-position) end (line-end-position)))
        (comment-or-uncomment-region beg end)))


;; define a shortcurt for above function
(global-set-key "\C-c\C-c" 'comment-or-uncomment-region-or-line)


;; definitions for projectile
;; (setq projectile-indexing-method 'git)
;; (setq projectile-enable-caching t)
;; (setq projectile-keymap-prefix (kbd "C-c C-p"))
;; (projectile-global-mode t)
;; (let ((ack_path "~/bin/ack"))
;;   (if (file-exists-p ack_path)
;;       (setq ack-and-a-half-executable ack_path)
;;   )
;; )

;; definition for guide-key, it is used automatic
(setq guide-key/guide-key-sequence
      '("C-x r" "C-x 4"
        (org-mode "C-c C-x")
        (outline-minor-mode "C-c @")))


;; enable line numbers
(global-nlinum-mode 1)


;; define fiplr for git repositories
(setq fiplr-root-markers '(".git"))
(global-set-key (kbd "C-x f") 'fiplr-find-file)
(setq fiplr-ignored-globs '((directories (".git" ".svn" ".ensime_lucene" "target"))
                            (files ("*.jpg" "*.png" "*.zip" "*~"))))
