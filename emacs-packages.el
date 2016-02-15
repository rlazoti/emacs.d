(require 'cl)
(require 'package)

(setq package-archives '(("elpa" . "http://elpa.gnu.org/packages/")
												 ("melpa" . "http://melpa.org/packages/")
												 ("melpa-stable" . "http://stable.melpa.org/packages/")
												 ("marmalade" . "http://marmalade-repo.org/packages/")))

;; always install the stable cider's version
(add-to-list 'package-pinned-packages '(cider . "melpa-stable") t)

;; set package-user-dir to be relative to Emacs install path
(setq package-user-dir (expand-file-name "packages" emacs-dir))
(package-initialize)


(when (not package-archive-contents)
  (package-refresh-contents))


(defvar emacs-packages '(epl)
  "A list of packages to ensure are installed at launch.")


(defun emacs-packages-installed-p ()
  "Check if all packages in `emacs-packages' are installed."
  (every #'package-installed-p emacs-packages))


(defun emacs-require-package (package)
  "Install PACKAGE unless already installed."
  (unless (memq package emacs-packages)
    (add-to-list 'emacs-packages package))
  (unless (package-installed-p package)
    (package-install package)))


(defun emacs-require-packages (packages)
  "Ensure PACKAGES are installed.
Missing packages are installed automatically."
  (mapc #'emacs-require-package packages))


(define-obsolete-function-alias 'emacs-ensure-module-deps 'emacs-require-packages)


(defun emacs-install-packages ()
  "Install all packages listed in `emacs-packages'."
  (unless (emacs-packages-installed-p)
    ;; check for new packages (package versions)
    (message "%s" "Emacs is now refreshing its package database...")
    (package-refresh-contents)
    (message "%s" " done.")
    ;; install the missing packages
    (emacs-require-packages emacs-packages)))


;; run package installation
(emacs-install-packages)


(defun emacs-list-foreign-packages ()
  "Browse third-party packages not bundled with Emacs.

Behaves similarly to `package-list-packages', but shows only the packages that
are installed and are not in `emacs-packages'.  Useful for
removing unwanted packages."
  (interactive)
  (package-show-package-list
   (set-difference package-activated-list emacs-packages)))


(provide 'emacs-packages)
