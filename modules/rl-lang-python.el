;;; rl-lang-python.el --- Python -*- lexical-binding: t; -*-
;;; Commentary:
;; Replaces the old modules/emacs-python.el.
;;
;; Not ported:
;; - pyvenv, pyvenv-auto, pyenv-mode, pythonic: pyvenv has had no release since
;;   2021 and none of the four is in the MELPA / GNU ELPA / NonGNU archives as
;;   of the archive cache refreshed on 2026-10-14.
;; - lsp-pyright + lsp-mode: Eglot knows pyright by itself.
;;
;; The pyright binary is NOT installed on this machine.  Eglot asks to download
;; it the first time it opens a Python file.  Install it yourself instead:
;;   pip install pyright      (or: npm install -g pyright)
;;
;; Virtual environments: Eglot and the shell see the same PATH, so activate the
;; interpreter per project with .dir-locals.el, for example:
;;   ((python-mode . ((python-interpreter . "./.venv/bin/python"))))

;;; Code:

(use-package python
  :ensure nil
  :interpreter "python"
  :custom
  (python-indent-guess-indent-offset t)
  (python-indent-guess-indent-offset-verbose nil)
  (python-shell-interpreter "python3")
  :config
  (add-hook 'python-mode-hook #'eglot-ensure)
  (add-hook 'python-ts-mode-hook #'eglot-ensure))

;; requirements.txt has no mode of its own in Emacs 31 (`pip-requirements' is
;; not bundled).  `conf-unix-mode' handles comments and key=value lines well.
(add-to-list 'auto-mode-alist
             (cons "requirements[^/]*\\.txt\\'" #'conf-unix-mode))

(provide 'rl-lang-python)
;;; rl-lang-python.el ends here
