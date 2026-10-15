;;; rl-undo.el --- Linear undo with persistence across restarts -*- lexical-binding: t; -*-
;;; Commentary:
;; Replaces the old modules/emacs-undo-tree.el.
;;
;; Why: GNU ELPA still ships undo-tree 0.8.2, the version the old config had,
;; but the author stopped developing it, and Emacs 28+ has a non-linear undo
;; system with much larger limits (the base configuration raises `undo-limit' and
;; friends by 13x).  undo-fu keeps that history and gives one key per undo and
;; one key per redo, which is what undo-tree was used for.
;;
;; Lost: the visualiser (old `s-/').  There is no equivalent.
;; Gained: `undo-fu-session' writes the undo history to var/ and restores it
;; after a restart.  The old config had `undo-tree-auto-save-history' set to
;; nil, so nothing was kept between sessions.
;;
;; C-z replaces `suspend-frame' (as in the old config).  Suspend is on C-x C-z.

;;; Code:

(use-package undo-fu
  :commands (undo-fu-only-undo undo-fu-only-redo undo-fu-only-redo-all
                               undo-fu-disable-checkpoint)
  :bind (("C-z"     . undo-fu-only-undo)
         ("C-S-z"   . undo-fu-only-redo)
         ("C-M-z"   . undo-fu-only-redo-all))
  :config
  (global-unset-key (kbd "C-z")))

(use-package undo-fu-session
  :custom
  (undo-fu-session-directory (expand-file-name "undo/" user-emacs-directory))
  (undo-fu-session-linear t)
  (undo-fu-session-compression 'zstd)
  ;; Buffers whose undo history is throwaway: saving it costs a file per
  ;; session for no benefit.
  (undo-fu-session-incompatible-major-modes '(Buffer-menu-mode dired-mode))
  :init (undo-fu-session-global-mode))

(provide 'rl-undo)
;;; rl-undo.el ends here
