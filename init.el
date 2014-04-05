;; define melpa repository
(when (>= emacs-major-version 24)
  (require 'package)
  (package-initialize)
  (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
  )


;; define alt as meta key
(setq x-alt-keysym 'meta)


;; enable highlighting matching delimiters
(show-paren-mode 1)
(highlight-symbol-mode 1)
(setq highlight-symbol-idle-delay 0.75)

;; enable cua-mode
(cua-mode t)
(setq cua-auto-tabify-rectangles nil) ;; Don't tabify after rectangle commands
(transient-mark-mode 1) ;; No region when it is not highlighted
(setq cua-keep-region-after-copy t) ;; Standard Windows behaviour
(global-set-key (kbd "M-A") 'cua-set-rectangle-mark)


;; open/close speedbar
(global-set-key [f6] 'sr-speedbar-toggle)


;;; I prefer cmd key for meta
(setq mac-option-key-is-meta nil
      mac-command-key-is-meta t
      mac-command-modifier 'meta
      mac-option-modifier 'none)


;; define default tab width
(setq default-tab-width 2)


;; define custom variables by emacs menu
(custom-set-variables
   ;; custom-set-variables was added by Custom.
   ;; If you edit it by hand, you could mess it up, so be careful.
   ;; Your init file should contain only one such instance.
   ;; If there is more than one, they won't work right.
   '(column-number-mode t)
   '(custom-enabled-themes (quote (wombat)))
   '(custom-safe-themes (quote ("73fe242ddbaf2b985689e6ec12e29fab2ecd59f765453ad0e93bc502e6e478d6" default)))
   '(menu-bar-mode nil)
   '(show-paren-mode t)
   '(size-indication-mode t)
   '(tool-bar-mode nil)
)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;; sr-speedbar custom defs
(setq make-backup-files nil)
(setq sr-speedbar-auto-refresh nil)
(setq sr-speedbar-max-width 72)
(setq sr-speedbar-width-x 50)
(setq sr-speedbar-width-console 50)
(setq speedbar-obj-do-check nil)
(setq speedbar-show-unknown-files t)
(setq speedbar-use-images nil)
(setq speedbar-vc-do-check nil)


;; config for smartparens (ruby)
;; get from http://crypt.codemancers.com/posts/2013-09-26-setting-up-emacs-as-development-environment-on-osx/
(require 'smartparens-config)
 (require 'smartparens-ruby)
 (smartparens-global-mode)
 (show-smartparens-global-mode t)
 (sp-with-modes '(rhtml-mode)
   (sp-local-pair "<" ">")
   (sp-local-pair "<%" "%>"))


;; define default mode for some extesion
(add-to-list 'auto-mode-alist '("\\.js\\'"         . js2-mode))
(add-to-list 'auto-mode-alist '(".*_EDITMSG\\'"    . log-entry-mode))
(add-to-list 'auto-mode-alist '("/_"               . sh-mode))
(add-to-list 'auto-mode-alist '("\\.sh$"           . sh-mode))
(add-to-list 'auto-mode-alist '("\\.bashrc"        . sh-mode))
(add-to-list 'auto-mode-alist '("\\.c$"            . c-mode))
(add-to-list 'auto-mode-alist '("\\.h$"            . c-mode))
(add-to-list 'auto-mode-alist '("\\.l$"            . c-mode))
(add-to-list 'auto-mode-alist '("\\.y$"            . c-mode))
(add-to-list 'auto-mode-alist '("\\.awk$"          . c-mode))
(add-to-list 'auto-mode-alist '("\\.cc$"           . c-mode))
(add-to-list 'auto-mode-alist '("\\.x$"            . c-mode))
(add-to-list 'auto-mode-alist '("\\.txt$"          . text-mode))
(add-to-list 'auto-mode-alist '("\\.text$"         . text-mode))
(add-to-list 'auto-mode-alist '("\\.tex$"          . latex-mode))
(add-to-list 'auto-mode-alist '("\\.sm$"           . latex-mode))
(add-to-list 'auto-mode-alist '("\\.sty$"          . latex-mode))
(add-to-list 'auto-mode-alist '("\\.bib$"          . bibtex-mode))
(add-to-list 'auto-mode-alist '("\\.el$"           . emacs-lisp-mode))
(add-to-list 'auto-mode-alist '("\\.tcl$"          . tcl-mode))
(add-to-list 'auto-mode-alist '("\\.java$"         . java-mode))
(add-to-list 'auto-mode-alist '("\\.html$"         . html-mode))
(add-to-list 'auto-mode-alist '("[]>:/]Makefile"   . makefile-mode))
(add-to-list 'auto-mode-alist '("[]>:/]\\..*emacs" . emacs-lisp-mode))
(add-to-list 'auto-mode-alist '("\\.php?$"         . php-mode))
(add-to-list 'auto-mode-alist '("\\.Xdefaults$"    . xrdb-mode))
(add-to-list 'auto-mode-alist '("\\.Xenvironment$" . xrdb-mode))
(add-to-list 'auto-mode-alist '("\\.Xresources$"   . xrdb-mode))
(add-to-list 'auto-mode-alist '("*.\\.ad$"         . xrdb-mode))
(add-to-list 'auto-mode-alist '("\\.tbl$"          . sql-mode))
(add-to-list 'auto-mode-alist '("\\.sp$"           . sql-mode))
(add-to-list 'auto-mode-alist '("\\.yml$"          . yaml-mode))


;; load the ensime lisp code...
(add-to-list 'load-path "/Users/rodrigolazoti/Programs/ensime_2.10.0-0.9.8.9/elisp/")
(require 'ensime)


;; This step causes the ensime-mode to be started whenever
;; scala-mode is started for a buffer. You may have to customize this step
;; if you're not using the standard scala mode.
;; (add-hook 'scala-mode-hook 'ensime-scala-mode-hook)


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


;; define fiplr for git repositories
(setq fiplr-root-markers '(".git"))
(global-set-key (kbd "C-x f") 'fiplr-find-file)
(setq fiplr-ignored-globs '((directories (".git" ".svn" ".ensime_lucene" "target" ".settings"))
                            (files ("*.cache" "*.cache#" "*.class" "*.Jpg" "*.png" "*.zip" "*~"))))
