;; (use-package ag
;;   :bind
;;   (:map global-map
;;         ("C-S-s" . ag-project-regexp))

;;   :init
;;   (setq ag-ignore-list
;;         '("log" "tmp" "bower_components" "node_modules" "dist" ".git" ".svn"
;;           "target" ".settings" "sorbet" "tmp" "gems"
;;           "\*.cache" "\*.cache#" "\*.class" "\*.Jpg" "\*.png" "\*.zip" "\*~"
;;           "\*.rbi" "\*.svg" "\*.log" ".DS_Store"))

;;   (setq ag-highlight-search t)
;;   (setq ag-reuse-buffers 't)
;;   (setq ag-reuse-window 't))

;; (use-package wgrep)
;; (use-package wgrep-ag
;;   :after wgrep ag)

(use-package deadgrep
  :bind
  (:map global-map
        ("C-S-s" . deadgrep))
)

(provide 'emacs-search)
