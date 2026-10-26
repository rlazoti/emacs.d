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

(defun rl-python-server-reports ()
  "Hand the diagnostics of this buffer to the Python server.
The other option is `rl-eglot-keep-flycheck'; this one is chosen because the
only Python checker Flycheck has on this machine is py_compile, which reports
syntax and nothing else, while pyright reports types, undefined names and
import errors.  The hook is added buffer-locally and tests `eglot-managed-p',
so a Python buffer with no server running keeps Flycheck and its syntax errors.
See rl-lsp.el."
  (add-hook 'eglot-managed-mode-hook #'rl-eglot-let-server-report nil t))

(use-package python
  :ensure nil
  :interpreter "python"
  :custom
  (python-indent-guess-indent-offset t)
  (python-indent-guess-indent-offset-verbose nil)
  (python-shell-interpreter "python3")
  :config
  (dolist (hook '(python-mode-hook python-ts-mode-hook))
    (add-hook hook #'eglot-ensure)
    (add-hook hook #'rl-python-server-reports)))

;; requirements.txt has no mode of its own in Emacs 31 (`pip-requirements' is
;; not bundled).  `conf-unix-mode' handles comments and key=value lines well.
(add-to-list 'auto-mode-alist
             (cons "requirements[^/]*\\.txt\\'" #'conf-unix-mode))

(provide 'rl-lang-python)
;;; rl-lang-python.el ends here
