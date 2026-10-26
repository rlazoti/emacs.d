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
;; - git-gutter-fringe (and fringe-helper): blamer already shows per-line blame
;;   in the margin, and Magit shows the hunks.  Two systems were enough.
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

(provide 'rl-git)
;;; rl-git.el ends here
