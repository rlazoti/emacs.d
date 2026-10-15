;;; pre-early-init.el --- Settings loaded before early-init.el -*- no-byte-compile: t; lexical-binding: t; -*-
;;; Commentary:
;; This file is mine.  early-init.el and init.el are the base configuration and
;; are never edited by hand; when they are replaced, only they are replaced.
;;
;; Everything that must exist before the GUI and the package system start goes
;; here.  The only item that must be here (and nowhere else) is the `var/'
;; redirection, because it changes where every later init file writes data.

;;; Code:

;;; Keep ~/.emacs.d clean by putting all generated state under var/
;; This must run before early-init.el, otherwise `package-user-dir' and the
;; compile cache are already fixed at their defaults.
(setq user-emacs-directory (expand-file-name "var/" minimal-emacs-user-directory)
      package-user-dir (expand-file-name "elpa" user-emacs-directory))

;; `package-user-dir' is set explicitly above.  Everything derived from
;; `user-emacs-directory' follows, because `native-compile.el' and friends load
;; later and use `locate-user-emacs-file' for their defaults.
;;
;; One exception, noticed rather than fixed: Emacs fixes the native-compilation
;; cache directory before any init file runs, using the directory it was started
;; with.  So `make compile' can leave an `eln-cache/' (a few dozen KB of
;; trampolines) at the repository root.  It is git-ignored; nothing else is
;; written there.

;;; base configuration knobs
;; Leave the menu bar, tool bar, scroll bar, dialogs and tooltips off.
;; Add symbols here to turn them back on, for example '(tool-bar dialogs).
(setq minimal-emacs-ui-features '())

;; A larger threshold after startup helps with tree-sitter and LSP buffers.
(setq minimal-emacs-gc-cons-threshold (* 64 1024 1024))

;; Show the buffer name in the title bar only.
(setq minimal-emacs-frame-title-format "%b - Emacs")

(provide 'pre-early-init)
;;; pre-early-init.el ends here
