(use-package buffer-move
  :bind
  (:map global-map
        ("C-c C-c <up>"    . 'buf-move-up)
        ("C-c C-c <down>"  . 'buf-move-down)
        ("C-c C-c <left>"  . 'buf-move-left)
        ("C-c C-c <right>" . 'buf-move-right)))

(provide 'emacs-buffer-move)
