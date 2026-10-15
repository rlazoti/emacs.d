;;; validate-config.el --- Check that every option this config sets exists  -*- lexical-binding: t; -*-
;;; Commentary:
;; Run with: make validate
;;
;; `setq' and the `:custom' keyword of `use-package' both accept a name that no
;; package ever defined.  Emacs then creates a variable that nothing reads, so
;; the setting looks fine and does nothing.  The old config had several of
;; those: `highlight-tabs', `package-native-compile',
;; `native-comp-deferred-compilation', and `indent-line-function' set to 2.
;;
;; This tool reads modules/ and modules-private/, takes the names used in
;; `:custom' and `:custom-face', and checks each one in three steps:
;;
;;   1. require the package named by the `use-package' form, then look for it;
;;   2. fail that, walk the name backwards over its dashes and require each
;;      prefix, because options often live in a secondary file of a package
;;      (`corfu-echo-documentation' is in corfu-echo.el);
;;   3. fail that, search the installed sources for the name.  Eshell keeps its
;;      options in esh-mode.el and em-*.el, which nothing requires at startup,
;;      so "not bound here" is not the same as "does not exist".
;;
;; Only a name that no file mentions at all is reported as undefined, and that
;; is what makes the target fail.  Step 3 is case sensitive and word bounded, so
;; `magit-clone-set-remote-HEAD' does not match the real
;; `magit-clone-set-remote-head'.

;;; Code:

(defconst rl-validate--dirs '("modules" "modules-private")
  "Directories to scan.")

(defun rl-validate--forms (file)
  "Top level forms of FILE."
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

(defun rl-validate--options (form keyword)
  "The option names that follow KEYWORD in a `use-package' FORM.
A `:custom' group is a list of (OPTION VALUE) pairs, so only the first element
of each pair is an option name."
  (let ((tail (member keyword form))
        collected)
    (when tail
      (setq tail (cdr tail))
      (let (current)
        (while (and tail
                    (not (and (symbolp (car tail))
                              (> (length (symbol-name (car tail))) 0)
                              (eq (aref (symbol-name (car tail)) 0) ?:))))
          (let ((item (car tail)))
            (cond
             ((and (consp item) (symbolp (car item))
                   (not (memq (car item) '(t nil))))
              (push (car item) current))
             ((and (symbolp item) (not (memq item '(t nil))))
              (push item current))))
          (setq tail (cdr tail)))
        (setq collected (nreverse current))))
    collected))

(defun rl-validate--collect ()
  "List of (FEATURE KEYWORD OPTION OPTION...)."
  (let ((out '()))
    (dolist (dir rl-validate--dirs)
      (dolist (file (directory-files dir t "\\.el\\'"))
        (dolist (form (rl-validate--forms file))
          (when (and (consp form) (eq (car form) 'use-package))
            (let ((feature (nth 1 form)))
              (when (symbolp feature)
                (dolist (keyword '(:custom :custom-face))
                  (let ((opts (rl-validate--options form keyword)))
                    (when opts (push (cons feature (cons keyword opts)) out))))))))))
    (nreverse out)))

(defun rl-validate--exists-p (sym kind)
  "Non-nil when SYM exists as a face (KIND `custom-face') or a value (else)."
  (cond
   ((eq kind :custom-face) (facep sym))
   ((custom-variable-p sym) t)
   ((boundp sym) t)
   (t nil)))

(defun rl-validate--load-owner (sym kind)
  "Return the feature that defines SYM, or nil.
Drop dash separated suffixes one at a time and require the result, stopping as
soon as SYM exists."
  (let* ((parts (split-string (symbol-name sym) "-"))
         (owner nil))
    (while (and (cdr parts) (not (rl-validate--exists-p sym kind)))
      (setq parts (butlast parts))
      (let ((feat (intern (mapconcat #'identity parts "-"))))
        (setq owner feat)
        (condition-case nil (require feat nil t) (error nil))))
    (and (rl-validate--exists-p sym kind) owner)))

(defvar rl-validate--source-files nil
  "Every .el and .elc file to search for option names, computed once.")

(defun rl-validate--source-files ()
  "Files to search: the installed packages plus the Emacs Lisp tree."
  (unless rl-validate--source-files
    (let ((roots (list package-user-dir
                       (file-name-directory (locate-library "isearch"))))
          (files '()))
      (dolist (root roots)
        (when (and root (file-directory-p root))
          (dolist (f (directory-files-recursively root "\\.elc?\\'"))
            (unless (string-match "-autoloads\\.elc?\\'" f)
              (push f files)))))
      (setq rl-validate--source-files (nreverse files))))
  rl-validate--source-files)

(defun rl-validate--mentions (names)
  "Alist of (NAME . FILE) for the option NAMES some source file mentions.
The search is case sensitive and word bounded, so a wrong case or a wrong
suffix does not match the name that really exists."
  (let ((case-fold-search nil)
        (pending (copy-sequence names))
        (found '()))
    (catch 'done
      (dolist (f (rl-validate--source-files))
        (with-temp-buffer
          (insert-file-contents f)
          (dolist (name pending)
            (goto-char (point-min))
            (when (re-search-forward (concat "\\b" (regexp-quote (symbol-name name)) "\\b")
                                     nil t)
              (push (cons name (file-name-nondirectory f)) found)
              (setq pending (delq name pending))))
          (when (null pending) (throw 'done nil)))))
    found))

(defun rl-validate-run ()
  "Load the packages this config declares and check the options it sets."
  (let ((entries (rl-validate--collect))
        (problems 0)
        (other-file 0)
        (checked 0)
        unknown)
    (dolist (entry entries)
      (let ((feature (car entry))
            (keyword (nth 1 entry))
            (symbols (nthcdr 2 entry)))
        ;; Step 1: the package named by the use-package form.
        (condition-case nil (require feature nil t) (error nil))
        (dolist (sym symbols)
          (setq checked (1+ checked))
          (unless (rl-validate--exists-p sym keyword)
            ;; Step 2: a secondary file of the same package.
            (let ((owner (rl-validate--load-owner sym keyword)))
              (if owner
                  (progn
                    (setq other-file (1+ other-file))
                    (princ (format "other file   %-42s %s (defined in %s.el)\n"
                                   sym keyword owner)))
                (push (list feature keyword sym) unknown)))))))
    ;; Step 3: search the sources for what is still unknown.
    (when unknown
      (let ((mentions (rl-validate--mentions (mapcar (lambda (e) (nth 2 e)) unknown))))
        (dolist (entry unknown)
          (pcase-let ((`(,feature ,keyword ,sym) entry))
            (let ((file (cdr (assq sym mentions))))
              (if file
                  (progn
                    (setq other-file (1+ other-file))
                    (princ (format "loaded later %-42s %s (named in %s)\n"
                                   sym keyword file)))
                (setq problems (1+ problems))
                (princ (format "UNDEFINED    %-42s %s (use-package %s)\n"
                               sym keyword feature))))))))
    (princ (format "\n%d options checked: %d undefined, %d defined outside what loads at startup\n"
                   checked problems other-file))
    (unless (zerop problems)
      (kill-emacs 1))))

;;; Point package.el at var/elpa: -Q loads no init file, and Emacs 31 `--batch'
;;; implies `-q', so nothing else would make the installed packages visible.
(require 'package)
(when load-file-name
  (setq user-emacs-directory (file-name-directory (expand-file-name load-file-name)))
  (setq package-user-dir (expand-file-name "var/elpa" user-emacs-directory)))
(package-initialize)

(rl-validate-run)

;;; validate-config.el ends here
