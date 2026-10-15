;;; rl-font.el --- Font and symbol fallbacks -*- lexical-binding: t; -*-
;;; Commentary:
;; Ported from the old modules/emacs-font.el.
;;
;; The 25-line hand written `composition-function-table' ligature table is not
;; ported.  It was expensive (one entry per character class, evaluated at
;; startup), it breaks when a font changes, and it is replaced by either:
;;   - the terminal doing nothing (the old table only helped GUI frames), or
;;   - `global-prettify-symbols-mode' plus `prettify-symbols-alist', or
;;   - the `ligature' package (MELPA), which knows the fonts and their OpenType
;;     features.  The commented block at the end of this file shows how.

;;; Code:

(defgroup rl-font nil
  "Font settings for this configuration."
  :group 'rl)

(defcustom rl-font-family "JetBrains Mono"
  "Monospace font used for the default face."
  :type 'string)

(defcustom rl-font-height 160
  "Height of the default face, in 1/10 pt."
  :type 'integer)

(defun rl-apply-default-font ()
  "Set the default font and the symbol fallback fonts of the selected frame."
  (when (display-graphic-p)
    (condition-case err
        (set-face-attribute 'default nil
                            :family rl-font-family
                            :height rl-font-height)
      (error
       (display-warning 'rl-font
                        (format "Font %s unavailable: %s"
                                rl-font-family (error-message-string err)))))
    ;; macOS: draw symbols and emoji with the system fonts, which cover far
    ;; more codepoints than any programming font.
    (when (eq system-type 'darwin)
      (set-fontset-font t 'symbol (font-spec :family "Apple Symbols") nil 'prepend)
      (set-fontset-font t 'symbol (font-spec :family "Apple Color Emoji") nil 'prepend))))

(if (display-graphic-p)
    (rl-apply-default-font)
  ;; `emacs --daemon' or a first terminal frame: apply it to every GUI frame.
  (add-hook 'after-make-frame-functions
            (lambda (frame)
              (with-selected-frame frame (rl-apply-default-font)))))

;; Modeline text scale does not resize the frame.
;; (The base configuration already sets `global-text-scale-adjust-resizes-frames'.)

;; Optional: real ligatures, if the font supports OpenType ligatures:
;;   (use-package ligature
;;     :config
;;     (ligature-set-features 'default))

(provide 'rl-font)
;;; rl-font.el ends here
