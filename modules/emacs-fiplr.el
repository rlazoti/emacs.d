(use-package fiplr
  :bind
  (:map global-map ("C-x f" . fiplr-find-file))
  :config
  (setq fiplr-root-markers '(".git"))
  (setq fiplr-ignored-globs '((directories ("tmp" "bower_components" "node_modules" "dist" ".git" ".svn" "target" ".settings"))
                              (files ("*.cache" "*.cache#" "*.class" "*.Jpg" "*.png" "*.zip" "*~" "*.log" ".DS_Store")))))

(provide 'emacs-fiplr)
