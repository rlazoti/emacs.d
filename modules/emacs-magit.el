(add-to-list 'package-pinned-packages '(magit . "melpa-stable") t)

(emacs-require-package 'magit)

;; Protect against accident pushes to upstream
(defadvice magit-push-current-to-upstream
    (around my-protect-accidental-magit-push-current-to-upstream)
  "Protect against accidental push to upstream.

Causes `magit-git-push' to ask the user for confirmation first."
  (let ((my-magit-ask-before-push t))
    ad-do-it))

(defadvice magit-git-push (around my-protect-accidental-magit-git-push)
  "Maybe ask the user for confirmation before pushing.

Advice to `magit-push-current-to-upstream' triggers this query."
  (if (bound-and-true-p my-magit-ask-before-push)
      ;; Arglist is (BRANCH TARGET ARGS)
      (if (yes-or-no-p (format "Push %s branch upstream to %s? "
                               (ad-get-arg 0) (ad-get-arg 1)))
          ad-do-it
        (error "Push to upstream aborted by user"))
    ad-do-it))

(ad-activate 'magit-push-current-to-upstream)
(ad-activate 'magit-git-push)

(provide 'emacs-magit)

