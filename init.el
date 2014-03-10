;; define melpa repository
(when (>= emacs-major-version 24)
  (require 'package)
  (package-initialize)
  (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
  )


;; define alt as meta key
(setq x-alt-keysym 'meta)


;; define that backup files won't be generated
(setq make-backup-files nil)


;; enable cua-mode
(cua-mode t)
(setq cua-auto-tabify-rectangles nil) ;; Don't tabify after rectangle commands
(transient-mark-mode 1) ;; No region when it is not highlighted
(setq cua-keep-region-after-copy t) ;; Standard Windows behaviour
(global-set-key (kbd "M-A") 'cua-set-rectangle-mark)


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


;; load the ensime lisp code...
(add-to-list 'load-path "~/Programs/ensime_2.10.0-0.9.8.9/elisp/")
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
