(use-package multiple-cursors
  :ensure t
	:bind
  (:map global-map
				("C-S-c C-S-c" . mc/edit-lines)
				("C->"         . mc/mark-next-like-this)
				("C-<"         . mc/mark-previous-like-this)
				("C-c C->"     . mc/mark-all-like-this)
				("C-."         . mc/mark-next-lines)
				("C-,"         . mc/mark-previous-lines)))

(provide 'emacs-multiple-cursors)
