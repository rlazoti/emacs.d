;;; rl-markdown.el --- Markdown and Mermaid -*- lexical-binding: t; -*-
;;; Commentary:
;; Ported from the old modules/emacs-markdown.el.
;;
;; Not ported:
;; - markdown-preview-mode: last release 2023, and its config pinned CDN
;;   assets from 2019 (highlight.js 9.15.6, github-markdown-css 3.0.1).
;; - (setq markdown-command "multimarkdown"): the multimarkdown binary is not
;;   installed, so `markdown' export and preview could not work anyway.
;; - the remap of the markdown heading-motion keys to `windmove'.  It made
;;   M-p / M-n change window instead of moving between headings, which is
;;   surprising.  The window chords in rl-keys.el (C-c arrows) already do that.
;;
;; If you want export and preview, install a converter first:
;;   brew install pandoc     then  (setq markdown-command "pandoc")
;;   brew install multimarkdown (keeps the old default command name)

;;; Code:

(use-package markdown-mode
  :mode ("README\\.md\\'" . gfm-mode)
  :custom
  (markdown-enable-wiki-links t)
  (markdown-asymmetric-header t)
  :hook (markdown-mode . superword-mode)) ; words are camelCase in docs too

(use-package mermaid-mode)

(provide 'rl-markdown)
;;; rl-markdown.el ends here
