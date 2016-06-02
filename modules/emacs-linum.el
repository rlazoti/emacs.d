(defun customize-linum-mode ()
  (interactive)
	(set-face-attribute 'linum nil :background "gray7"))

(add-hook 'linum-mode-hook 'customize-linum-mode)

(define-global-minor-mode custom-linum-mode linum-mode
  (lambda ()
    (when (not (memq major-mode
                     (list 'help-mode 'shell-mode 'speedbar-mode)))
      (linum-mode 1))))

(custom-linum-mode 1)

(provide 'emacs-linum)
