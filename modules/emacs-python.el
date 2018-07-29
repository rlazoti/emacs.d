(emacs-require-packages '(elpy))

(add-hook 'elpy-mode-hook 'flycheck-mode)
(elpy-enable)

(provide 'emacs-python)
