(emacs-require-package 'pig-mode)

(require 'pig-mode)

(setq pig-executable "~/Programs/pig/bin/pig")
(setq pig-executable-options '("-x" "local"))
(setq pig-executable-prompt-regexp "^grunt> ")
(setq pig-indent-level 2)
(setq pig-version "0.13.0")

(provide 'emacs-pig)