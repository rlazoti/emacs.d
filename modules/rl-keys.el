;;; rl-keys.el --- Global keybindings for built-in commands -*- lexical-binding: t; -*-
;;; Commentary:
;; Bindings of built-in commands and of the commands defined in rl-core.el and
;; rl-editor.el.  A package binds its own keys inside its own `use-package'
;; form, so that it stays lazy.  Readme table: README.md lists every chord.
;;
;; Two chords deliberately reproduce the old config, even though they replace
;; common defaults:
;;   C-l     -> goto line (with preview) instead of `recenter-top-bottom'
;;   C-z     -> undo instead of `suspend-frame'  (bound in rl-undo.el)
;; The replaced commands are still reachable: recenter is on `C-l C-l' here,
;; and suspending Emacs is on `C-x C-z'.

;;; Code:

(use-package emacs
  :ensure nil
  :bind
  (;; Quit any prompt, minibuffer or keyboard macro with a single key.
   ("<escape>" . keyboard-escape-quit)

   ;; Buffers
   ("C-x k" . kill-current-buffer)
   ("C-c n" . rl-new-untitled-buffer)
   ([remap next-buffer]     . rl-next-code-buffer)
   ([remap previous-buffer] . rl-previous-code-buffer)

   ;; Windows.  The frame is usually split left/right, so these match the
   ;; physical layout of the keys.
   ("C-c <left>"  . windmove-left)
   ("C-c <right>" . windmove-right)
   ("C-c <up>"    . windmove-up)
   ("C-c <down>"  . windmove-down)

   ;; Scrolling: keep point where it is.
   ("C-<up>"   . rl-scroll-down-keep-cursor)
   ("C-<down>" . rl-scroll-up-keep-cursor)

   ;; Text scale.  `global-text-scale-adjust' would grab C-x C-+ as well.
   ("C-+" . text-scale-increase)
   ("C--" . text-scale-decrease)

   ;; Search and replace
   ("C-c r" . replace-string)
   ("C-c C-s" . isearch-forward-thing-at-point) ; region if active, else point
   ("C-c a" . align-regexp)

   ;; Line numbers.  The old config used C-l for `goto-line', so
   ;; `recenter-top-bottom' is left unbound (it is on M-x recenter-top-bottom).
   ("C-l" . goto-line)

   ;; Case
   ("M-u" . upcase-word)
   ("M-l" . downcase-word)
   ("M-c" . capitalize-word)
   ("M-U" . upcase-region)
   ("M-L" . downcase-region)
   ("M-C" . capitalize-region)))

;; `goto-line' is remapped to `goto-line-preview' by rl-editor.el, so C-l shows
;; the line under the cursor before jumping, and `recenter-top-bottom' stays
;; reachable through M-x.

(provide 'rl-keys)
;;; rl-keys.el ends here
