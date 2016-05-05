(emacs-require-packages '(elisp-slime-nav common-lisp-snippets slime slime-company))

(require 'elisp-slime-nav)

(dolist (hook '(emacs-lisp-mode-hook ielm-mode-hook))
	(add-hook hook 'turn-on-elisp-slime-nav-mode))

(add-hook 'slime-mode-hook '(lambda ()
  (local-set-key (kbd "C-c C-b") ' slime-repl-clear-buffer)))


(setq slime-contribs '(slime-fancy slime-company))
(setq inferior-lisp-program "/usr/local/bin/sbcl")

(provide 'emacs-elisp)
