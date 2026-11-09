;;; rl-search.el --- Search in files, edit matches -*- lexical-binding: t; -*-
;;; Commentary:
;; Ported from the old modules/emacs-search.el.
;;
;; The commented `ag' block is gone: `ag' is not installed, `rg' is, and
;; deadgrep uses `rg'.  wgrep is kept so a search result can be edited and
;; saved.  The plain isearch key chords stay as Emacs defines them.
;;
;; Chords:
;;   C-c s   deadgrep (project-wide ripgrep search buffer)
;;   C-S-s   the same, on a graphical frame only
;;   M-s r   consult-ripgrep (one-shot, with preview)      [rl-completion.el]
;;   M-s g   consult-grep
;;   M-s G   consult-git-grep
;;   C-x f   projectile-find-file                          [rl-projects.el]
;; In a deadgrep or Consult result buffer, press C-e (Embark export) then
;; `wgrep-change-to-wgrep-mode' to edit the matches in place.
;;
;; Why two chords for one command: a text terminal cannot deliver Ctrl+Shift with
;; a letter on it, because `xterm-function-map' -- the only modified-key decoder
;; a terminal frame has -- has no entry for one.  `C-S-s' therefore arrives as
;; `C-s', which is `isearch-forward'.  `C-c s' is the one that works everywhere;
;; `C-S-s' stays because it is the chord the GUI habit already built.  The
;; measurement and the rest of the affected chords are in `rl-terminal.el'.

;;; Code:

(use-package deadgrep
  :bind (("C-c s" . deadgrep)
         ("C-S-s" . deadgrep))
  :custom
  (deadgrep-project-root-function #'projectile-project-root)
  (deadgrep-extra-arguments '("--follow"))
  :preface
  (defun rl-deadgrep-project-root ()
    "Project root from Projectile, or the current directory."
    (if (and (fboundp 'projectile-project-p) (projectile-project-p))
        (projectile-project-root)
      default-directory))
  :config
  (setq deadgrep-project-root-function #'rl-deadgrep-project-root))

(use-package wgrep
  :commands (wgrep-change-to-wgrep-mode wgrep-finish-edit)
  :custom
  (wgrep-auto-save-buffer t)
  (wgrep-change-readonly-file t))

(provide 'rl-search)
;;; rl-search.el ends here
