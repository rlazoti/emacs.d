;;; package-deps.el --- List or install the packages the modules declare  -*- lexical-binding: t; -*-
;;; Commentary:
;; Run with:
;;   make list-deps      print the external packages the modules declare
;;   make install-deps   install the missing ones (needs network)
;;
;; It scans modules/ and modules-private/ for (use-package NAME ...) forms and
;; skips the ones that carry `:ensure nil' (built-in libraries).
;;
;; Why this file configures package.el itself: in Emacs 31 `--batch' implies
;; `-q', so a batch run loads neither early-init.el nor init.el.  Without this
;; setup, package.el would use its defaults (GNU ELPA and NonGNU ELPA only, and
;; <config>/elpa instead of <config>/var/elpa) and every MELPA package would
;; fail to install.
;;
;; An interactive first start of this config does not need any of this: it
;; installs what it needs on its own, because the base configuration sets
;; `use-package-always-ensure' for interactive sessions.

;;; Code:

(defconst rl-deps--dirs '("modules" "modules-private")
  "Directories to scan for `use-package' forms, relative to the config root.")

(defconst rl-deps--never-packages '(emacs vc use-package)
  "`use-package' names that are never a package to install.")

(defconst rl-deps--archives
  '(("melpa" . "https://melpa.org/packages/")
    ("gnu"   . "https://elpa.gnu.org/packages/")
    ("nongnu" . "https://elpa.nongnu.org/nongnu/"))
  "The same archives the base configuration uses, minus melpa-stable.")

(defconst rl-deps--root
   (and load-file-name (file-name-directory (expand-file-name load-file-name)))
  "Directory that holds this file, which is the configuration root.")

(defun rl-deps--setup ()
  "Point package.el at this configuration's var/elpa and set the archives."
  (require 'package)
  (if (not rl-deps--root)
      (display-warning 'rl-deps
                       "Load this file with -l package-deps.el from the config root")
    (setq user-emacs-directory rl-deps--root)
    (setq package-user-dir (expand-file-name "var/elpa" rl-deps--root))
    (setq package-archives rl-deps--archives)
    (setq package-enable-at-startup nil)
    (make-directory package-user-dir t)))

(defun rl-deps--forms (file)
  "Return the top level forms of FILE."
  (with-temp-buffer
    (emacs-lisp-mode)               ; in fundamental mode `;' is not a comment
    (insert-file-contents file)
    (goto-char (point-min))
    (let (acc)
      (condition-case nil
          (while (not (eobp))
            (push (read (current-buffer)) acc))
        (end-of-file nil))
      (nreverse acc))))

(defun rl-deps--ensure-nil-p (form)
  "Non-nil when the `use-package' FORM contains `:ensure nil'."
  (let ((tail (member :ensure form)))
    (and tail (null (nth 1 tail)))))

(defun rl-deps--collect ()
  "Alist of (NAME . FILE) for the packages the modules need."
  (let (found)
    (dolist (dir rl-deps--dirs)
      (let ((dir (expand-file-name dir (or rl-deps--root default-directory))))
        (dolist (file (directory-files dir t "\\.el\\'"))
          (dolist (form (rl-deps--forms file))
            (when (and (consp form) (eq (car form) 'use-package))
              (let ((name (nth 1 form)))
                (when (and (symbolp name)
                           (not (memq name rl-deps--never-packages))
                           (not (rl-deps--ensure-nil-p form))
                           (not (assq name found)))
                  (push (cons name file) found))))))))
    (sort found (lambda (a b) (string< (symbol-name (car a))
                                       (symbol-name (car b)))))))
(defun rl-deps-list ()
  "Print the declared packages with the file that declares them."
  (let ((alist (rl-deps--collect)))
    (dolist (entry alist)
      (princ (format "%-24s %s\n" (car entry)
                     (file-name-nondirectory (cdr entry)))))
    (princ (format "\n%d packages\n" (length alist)))
    (mapcar #'car alist)))

(defun rl-deps-install ()
  "Install every declared package that is not installed yet."
  (rl-deps--setup)
  (unless package-archive-contents
    (package-refresh-contents))
  (let ((names (mapcar #'car (rl-deps--collect))))
    (princ (format "Declaring %d packages into %s\n"
                   (length names) package-user-dir))
    (dolist (name names)
      (cond
       ((package-installed-p name)
        (princ (format "ok       %s\n" name)))
       ((not (assq name package-archive-contents))
        (princ (format "MISSING  %s (not in the archives)\n" name)))
       (t
        (condition-case err
            (progn
              (princ (format "install  %s\n" name))
              (package-install name))
          (error
           (princ (format "FAILED   %s: %s\n" name
                          (error-message-string err))))))))
    (princ (format "Done: %d of %d installed\n"
                   (length (seq-filter #'package-installed-p names))
                   (length names)))))

(let ((args command-line-args-left))
  (if (member "--install" args)
      (rl-deps-install)
    (rl-deps-list)))

;;; package-deps.el ends here
