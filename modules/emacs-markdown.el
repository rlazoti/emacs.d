(use-package markdown-mode
  :ensure t
  :mode ("README\\.md\\'" . gfm-mode)
  :init (setq markdown-command "multimarkdown")
  :bind (([remap markdown-move-up] . windmove-up)
         ([remap markdown-move-down] . windmove-down)
         ([remap markdown-promote] . windmove-left)
         ([remap markdown-demote] . windmove-right)))

(provide 'emacs-markdown)
