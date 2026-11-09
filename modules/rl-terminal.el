;;; rl-terminal.el --- Bring a text terminal frame up to GUI behaviour -*- lexical-binding: t; -*-

;;; Commentary:
;; Loaded by `post-init.el' when Emacs starts without graphics, which is what
;; `et' (`emacs -nw') does.  The stack here is iTerm2 -> tmux -> Emacs, so
;; `$TERM' is `screen-256color' and Emacs initialises the terminal with
;; `term/screen.el' instead of `term/xterm.el'; `term/tmux.el' does the same for
;; `TERM=tmux*'.  Both run the xterm initialiser with a capability list of their
;; own, and that is where two of the three differences below come from.
;;
;; What is NOT here, because no setting can fix it: a text terminal cannot
;; deliver a chord that puts Shift on a letter, or on most punctuation.  Measured
;; with `lookup-key' against `xterm-function-map' -- the only modified-key
;; decoder a text frame has -- on Emacs 31.1:
;;
;;   ESC [ 27 ; 5 ; 115 ~  (modifyOtherKeys form of C-S-s)  -> prefix only
;;   ESC [ 115 ; 6 u       (CSI-u form, what tmux forwards) -> prefix only
;;   ESC [ 27 ; 5 ; 122 ~  (C-S-z)                          -> prefix only
;;   ESC [ 27 ; 6 ; 46 ~   (C-S-. i.e. C->)                 -> prefix only
;;
;; The decoder's table is a fixed list of Ctrl/Meta with punctuation plus tab,
;; return and space, so those chords have no event to name: `C-S-s' arrives as
;; `C-s' (`isearch-forward') and `C-S-z' as `C-z'.  Emacs 31 has no kitty
;; keyboard protocol decoder either -- `xterm-function-map' has no `u'-
;; terminating entries -- so this is not a tmux or an iTerm2 setting, and no
;; `extended-keys' line changes it.
;;
;; `C-tab', `C-S-tab', `C-,', `C-.' and modified arrows ARE decodable; whether
;; the terminal sends them in that form is a separate question, and `C-h k' in
;; the real frame answers it in a second.  Shift+Space arrives as Meta+Space,
;; which is `cycle-spacing' here, so Embark is reached with `C-;' (decodable) in
;; a terminal.  The commands that lost a chord got a second chord in the module
;; that owns them -- `rl-search.el', `rl-undo.el', `rl-editor.el' -- so those
;; work in both kinds of frame.  Only the machinery below is terminal specific.
;;
;; Three checks settle anything this file ever gets wrong, in an `et' frame:
;;
;;   M-: (featurep 'xterm)                               -> t, via term/screen.el
;;   M-: (terminal-parameter nil 'xterm--set-selection)  -> t means OSC 52 is armed
;;   M-: (xterm-mouse-mode)                              -> t means clicks are armed
;;
;; `M-x rl-doctor' prints the last two from inside the frame that has them.
;;
;;; Code:

;;; Clipboard, out
;;
;; The path is `interprogram-cut-function' -- default `gui-select-text', not nil,
;; so there is no per-frame function to install -- into `gui-set-selection',
;; which dispatches to a `gui-backend-set-selection' method specialised on
;; `(window-system nil)' AND on `(terminal-parameter nil 'xterm--set-selection)'
;; being t (`term/xterm.el').  That parameter is set only by
;; `xterm--init-activate-set-selection', and `term/screen.el' calls it only when
;; `setSelection' is in `xterm-screen-extra-capabilities', whose default is
;; `(modifyOtherKeys)' alone.  So `M-w' did run and did reach
;; `gui-set-selection', where no method applied: nothing was sent, and nothing
;; said so.  `term/tmux.el' has the same default and the same fix.
;;
;; The method is written for exactly this stack: when the terminal was
;; initialised by `terminal-init-screen' it wraps the OSC 52 in a Device Control
;; String and splits long ones, because it knows it is inside screen/tmux.
;;
;; `getSelection' is deliberately not added along with it.  Emacs 31 refuses that
;; path under screen outright -- the `gui-backend-get-selection' method carries
;; `((eq (terminal-parameter nil 'terminal-initted) 'terminal-init-screen) (eql
;; nil))' in its specialiser, citing bug#36879 -- and `pbpaste' below is local,
;; exact and always present on macOS.  The size limit on the way out is
;; `xterm-max-cut-length' (100000 bytes of base64, so roughly 75 KB of text).
(with-eval-after-load 'term/screen
  (add-to-list 'xterm-screen-extra-capabilities 'setSelection))
(with-eval-after-load 'term/tmux
  (add-to-list 'xterm-tmux-extra-capabilities 'setSelection))

;;; Clipboard, in
;;
;; The terminal driver turns bracketed paste mode on unconditionally, so Cmd-V in
;; a terminal arrives as one paste event and inserts as text; that half already
;; worked, and `xterm-store-paste-on-kill-ring' (default t) puts it in the kill
;; ring.  The half that did not is `C-y' for something copied in another
;; application: the kill ring is all it has ever seen.
(defun rl-terminal-clipboard-paste ()
  "Return the macOS clipboard, or nil when it holds what Emacs last killed.
`yank' calls `interprogram-paste-function' with no arguments before falling
back to the kill ring, so nil means \"use the kill ring\".  Its contract asks
for nil when the clipboard holds the text Emacs supplied last, and an OSC 52
cut puts that text on the clipboard and in the kill ring at once, so comparing
against the head of the kill ring is what keeps `C-y' straight after `M-w'
from inserting the same text twice."
  (let ((pbpaste (executable-find "pbpaste")))
    (when pbpaste
      (let ((text (with-temp-buffer
                    (and (= 0 (call-process pbpaste nil t nil))
                         (buffer-string)))))
        (when (and text (> (length text) 0))
          (unless (and (consp kill-ring)
                       (equal text (substring-no-properties (car kill-ring))))
            text))))))

(setq interprogram-paste-function #'rl-terminal-clipboard-paste)

;;; Mouse
;;
;; The terminal driver enables `xterm-mouse-mode' by itself only when the
;; XTVERSION query answers a name in `xterm--auto-xt-mouse-allowed-names' --
;; iTerm2 is on that list -- and tmux does not answer that query, so a pane gets
;; no clicks and the `mouse-yank-at-point' in `init.el' has nothing to act on.
;; Hooked rather than called once, because `tty-setup-hook' runs for each new
;; terminal frame as well as the first (`startup.el', `faces.el').
;;
;; tmux keeps its own `mouse on' in front of Emacs.  Option in iTerm2 bypasses
;; mouse reporting, which is how tmux's copy-mode stays reachable from inside an
;; Emacs pane.
(defun rl-terminal-mouse ()
  "Turn on xterm mouse reporting in this terminal frame."
  (require 'xt-mouse)
  (xterm-mouse-mode 1))

;; `--batch' implies `-q', so the checks that load this repository would
;; otherwise ask a nonexistent terminal to report clicks.
(unless noninteractive
  (add-hook 'tty-setup-hook #'rl-terminal-mouse))

;;; Marks, without a fringe
;;
;; A terminal frame has no fringe, so `flycheck-indication-mode' set to
;; `right-fringe' in `rl-check.el' drops the diagnostic marks silently.  The
;; margin is what diff-hl already falls back to (`diff-hl-fallback-to-margin',
;; `rl-git.el') on the LEFT, hence right here: the two sets of marks stay on
;; opposite sides of the text.
;;
;; Both forms say `:defer t' so that asking for an option cannot load the
;; package at startup, which is what a `:custom'-only form would otherwise do.
(use-package flycheck
  :defer t
  :custom (flycheck-indication-mode 'right-margin))

;; Bars drawn as a background colour get quantised to the 256 colours a terminal
;; offers; the character bars carry the same information with no palette in it.
(use-package indent-bars
  :defer t
  :custom (indent-bars-prefer-character t))

;;; Not changed, on purpose
;;
;; Icons: `doom-modeline-icon' (rl-ui.el) and the nerd-icons characters in
;; Treemacs insert a code point either way, and in a terminal the font that draws
;; it is iTerm2's, which here has SymbolsNFM as its non-ASCII font.  If a mode
;; line ever shows boxes, `(setq doom-modeline-icon nil)' is the fix, not this
;; file.
;;
;; Fonts: `rl-font.el' sets fonts only on a graphical frame, which is correct --
;; a terminal frame has no font of its own to set.
;;
;; `C-x 5 2' and `other-frame' mean a second *terminal* here, so a second tmux
;; window rather than a second window.  `display-buffer', Vertico, Consult,
;; Magit, Eglot and ediff behave the same in both.

(provide 'rl-terminal)
;;; rl-terminal.el ends here
