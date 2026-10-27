;;; rl-git.el --- Magit, blame, links, history -*- lexical-binding: t; -*-
;;; Commentary:
;; Ported from the old modules/emacs-git.el, emacs-blamer.el,
;; emacs-git-timemachine.el and emacs-git-gutter-fringe.el.
;;
;; Removed on purpose:
;; - magit-delta: the `delta' binary is not installed, and the face hacks plus
;;   the `seq-difference' hook workaround were fragile across Magit upgrades.
;;   Magit's own diff faces are good enough.  If you want delta: brew install
;;   git-delta, then add the `magit-delta' package back.
;; - git-gutter-fringe (and fringe-helper), briefly.  The stated reason was that
;;   Blamer shows per-line blame in the margin and Magit shows the hunks, so two
;;   systems were enough -- but that reasoning missed the question the marks answer
;;   and neither of those two does: "which lines am I about to commit".  Changed
;;   lines are marked again below, with `diff-hl', because it needs no polling
;;   timer, no fringe-helper, and knows about untracked files.
;; - forge: it was commented out in the old config and needs a token.
;;
;; The blamer callback that called `browse-at-remote--commit-url' (a private
;; function of another package) is not ported.  Open the remote from Magit
;; instead: in a Magit status/log buffer, `M RET' or the browse menu.

;;; Code:

(use-package magit
  :commands (magit-status magit-blame)
  :bind (("C-x g" . magit-status)
         ("C-x M-g" . magit-dispatch))
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1)
  (magit-clone-set-remote-head t)
  (magit-define-global-key-bindings 'not-conflicting)
  :config
  ;; Show the current branch in the mode line without loading Magit:
  ;; vc-mode does that.
  (setq vc-handled-backends '(Git)))

(use-package blamer
  :commands (global-blamer-mode blamer-mode blamer-show-commit-info)
  :custom
  (blamer-idle-time 2)
  (blamer-min-offset 70)
  (blamer-type 'visual)
  (blamer-prettify-time-p t)
  :custom-face
  (blamer-face ((t :foreground "#787BE5" :background unspecified
                   :height 140 :italic t)))
  :config
  (setq blamer-bindings
        '(("<mouse-1>" . rl-blamer-show-commit-diff))))

;;; Starting Blamer without paying for it at startup
;; `global-blamer-mode' is a globalized minor mode: turning it on once covers
;; every buffer, present and future, so it does not have to happen during init.
;; It is worth 350 ms of the 2.4 s this configuration takes, because blamer.el
;; pulls Magit in to read a commit.  An idle timer keeps the behaviour identical
;; where it is observable at all: Blamer itself waits `blamer-idle-time' (2 s)
;; before drawing anything, so loading it in the first idle moment after startup
;; cannot be seen.  A timer does not run in batch, which is also why
;; `make check-load' cannot catch a mistake here -- the commands being
;; autoloaded are what prove it still loads.
(defun rl-blamer-start ()
  "Load Blamer and turn it on for every buffer."
  (global-blamer-mode 1))

(run-with-idle-timer 0.5 nil #'rl-blamer-start)

(defun rl-blamer-show-commit-diff (commit-info)
  "Show the diff of the commit COMMIT-INFO in Magit."
  (let ((commit-hash (plist-get commit-info :commit-hash)))
    (when commit-hash
      (magit-show-commit commit-hash))))

(use-package browse-at-remote
  :commands (browse-at-remote browse-at-remote-get-url))

(use-package git-link
  :bind (("C-c g l" . git-link))
  :custom
  (git-link-open-in-browser t))

(use-package git-timemachine
  :commands git-timemachine)

(use-package ediff
  :ensure nil
  :defer t                       ; nothing here is read before Ediff runs
  :custom
  ;; Put the Ediff windows and the frame on the same level (base sets the same
  ;; value; kept here so the intent survives an upstream change).
  (ediff-window-setup-function #'ediff-setup-windows-plain)
  (ediff-split-window-function #'split-window-horizontally))

;;; Which lines does git think are different?
;; Fringe markers for the hunks `git diff' would show.  The port dropped this with
;; the argument that Blamer and Magit already cover it, and that argument was
;; wrong: Blamer answers "who last touched this line", Magit answers "what is
;; different about the repository", and neither answers "which lines am I about to
;; commit" while the file is being typed in.  The old setup used
;; `git-gutter-fringe' on `prog-mode', left fringe, refreshed on a 3 second timer.
;;
;; prog-mode and text-mode: code, Org and Markdown get marks, `package.json' and a
;; `.toml' do not, because those files are often dirty for reasons unrelated to the
;; edit at point.  `diff-hl-mode' does nothing in a buffer with no working tree, so
;; the hook costs nothing in a scratch buffer or in a file outside a repository.
;;
;; Marked on save, not while typing: `diff-hl-flydiff-mode' tracks the buffer as it
;; changes, which is one `git diff' per idle pause and worth measuring before
;; keeping.
;;
;; Nothing has to be wired up for Magit: since 1.11 `diff-hl-mode' installs its own
;; buffer-local `magit-revert-buffer-hook' and `magit-not-reverted-hook' pointing at
;; `diff-hl-update', which is what keeps the marks honest after a commit or a revert.
;; The `diff-hl-magit-post-refresh' hook the older manuals tell you to add is an
;; obsolete alias now and `diff-hl-magit.el' no longer ships -- checked against
;; diff-hl 20261001.135, because this configuration was about to require it.

;;;###autoload
(defvar rl-diff-hl-skipped-modes
  '(json-mode json-ts-mode js-json-mode toml-mode toml-ts-mode yaml-mode yaml-ts-mode)
  "Data-file modes that get no marks, although a hook on the two families would
give them some: `json-ts-mode' derives from `prog-mode' and `yaml-ts-mode' from
`text-mode'.  Those files are usually dirty because of a lockfile, a formatter or
a dependency bump rather than because of the edit at point, and a mark that is
always there stops being read.")

;; The minor mode itself, which the hook on the form below asks for.  Defined
;; before the form on purpose: shown an undefined name, `use-package' emits an
;; `autoload' for it pointing at the package, and this defun then quietly replaces
;; that -- harmless, and exactly the sort of thing that reads as magic a month
;; later.  Outside a working tree `diff-hl-mode' does nothing, so the hook costs
;; nothing in a scratch buffer or in a file that is not in a repository.
(defun rl-diff-hl-mode ()
  "Turn on `diff-hl-mode' here, unless this is a data file.
Hooked on `prog-mode-hook' and `text-mode-hook'; the two families alone are not
the whole answer, see `rl-diff-hl-skipped-modes'."
  (unless (apply #'derived-mode-p rl-diff-hl-skipped-modes)
    (diff-hl-mode 1)))

(use-package diff-hl
  :hook ((prog-mode text-mode) . rl-diff-hl-mode)
  :custom
  ;; Left fringe: where the old marks were, and the free fringe here, since
  ;; `flycheck-indication-mode' puts diagnostics on the right (see `rl-check.el').
  ;; Two systems that both want the same pixel read as noise.  `left' is also
  ;; diff-hl's own default; it is named here so the arrangement stays deliberate.
  (diff-hl-side 'left)
  ;; On a text terminal the marks move to a one-column margin instead of disappearing
  ;; with the fringe.  diff-hl's default again, and worth knowing when a TTY frame
  ;; looks different for no apparent reason.
  (diff-hl-fallback-to-margin t))

(provide 'rl-git)
;;; rl-git.el ends here
