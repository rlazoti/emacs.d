;;; rl-macos.el --- macOS specific settings -*- lexical-binding: t; -*-
;;; Commentary:
;; Ported from the old modules/emacs-osx.el.  Loaded by post-init.el only when
;; `system-type' is darwin.
;;
;; The old module called `custom-set-variables' for
;; `mac-emulate-three-button-mouse'.  That option belonged to the old Carbon Mac
;; port and no longer exists in the Nextstep build Emacs 31 uses, so the setting
;; is gone rather than ported: middle click is `C-y' (paste) in Emacs, and macOS
;; itself decides when a trackpad gesture becomes a secondary button.
;;
;; `exec-path-from-shell' lives in rl-run.el, because flycheck, eglot, rg and
;; quickrun need the same PATH fix and they are not macOS specific.

;;; Code:

(use-package emacs
  :ensure nil
  :custom
  ;; Keyboard: Cmd is Super, Option is Meta, the Fn key is Hyper.
  (mac-command-modifier 'super)
  (mac-option-modifier 'meta)
  (mac-control-modifier 'control)
  (ns-function-modifier 'hyper)
  ;; Keep the right Option key free for accented input (pt-BR).
  (ns-right-alternate-modifier nil)
  ;; The ls of macOS has no --dired, so Dired must not call it.
  (dired-use-ls-dired nil))

(provide 'rl-macos)
;;; rl-macos.el ends here
