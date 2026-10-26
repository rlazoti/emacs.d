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
;; markdown-mode binds C-c <left>/<right>/<up>/<down> to subtree and heading
;; edits, which are the window chords of rl-keys.el.  A major mode map beats
;; the global map, so those four chords did nothing useful in a Markdown
;; buffer.  They are unbound below; markdown-mode ships replacements for all
;; of them, listed next to each unbind.
;;
;; If you want export and preview, install a converter first:
;;   brew install pandoc     then  (setq markdown-command "pandoc")
;;   brew install multimarkdown (keeps the old default command name)

;;; Code:

(use-package markdown-mode
  :mode ("README\\.md\\'" . gfm-mode)
  :bind
  (:map markdown-mode-map
         ("C-c <left>"  . nil) ; markdown-promote    -> C-c C--  or C-c C-x l
         ("C-c <right>" . nil) ; markdown-demote     -> C-c C-=  or C-c C-x r
         ("C-c <up>"    . nil) ; markdown-move-up    -> C-c C-x u
         ("C-c <down>"  . nil)) ; markdown-move-down -> C-c C-x d
  :custom
  (markdown-enable-wiki-links t)
  (markdown-asymmetric-header t)
  :hook (markdown-mode . superword-mode)) ; words are camelCase in docs too

(use-package mermaid-mode :defer t)          ; a mode you visit, not a default

(provide 'rl-markdown)
;;; rl-markdown.el ends here
