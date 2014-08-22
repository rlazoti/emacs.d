(emacs-require-package 'fiplr)


;; define fiplr for git repositories
(setq fiplr-root-markers '(".git"))
(global-set-key (kbd "C-x f") 'fiplr-find-file)
(setq fiplr-ignored-globs '((directories (".git" ".svn" ".ensime_lucene" "target" ".settings" ".ensime_cache"))
                            (files ("*.cache" "*.cache#" "*.class" "*.Jpg" "*.png" "*.zip" "*~" "*.log"))))


(provide 'emacs-fiplr)
