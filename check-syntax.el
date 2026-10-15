;;; check-syntax.el --- Read every .el file in this repository  -*- lexical-binding: t; -*-
;;; Commentary:
;; Run with: make check-syntax
;;
;; It does not load anything.  It reads every top level form of every .el file
;; and reports the files that do not read cleanly, which catches unbalanced
;; parentheses, stray quotes and invalid characters.  A trailing newline after
;; the last form is not an error.

;;; Code:

(defconst rl-check--dirs '("." "modules" "modules-private")
  "Directories to scan.")

(defun rl-check--files ()
  "Every .el file under `rl-check--dirs', except this file."
  (let ((found '()))
    (dolist (dir rl-check--dirs)
      (dolist (f (directory-files dir t "\\.el\\'"))
        (unless (equal (file-name-nondirectory f) "check-syntax.el")
          (push f found))))
    (nreverse found)))

(defun rl-check--reads-cleanly (file)
  "Return nil when FILE cannot be read to the end.
Two things are needed for this check to mean anything.  The buffer must be in
`emacs-lisp-mode', because in `fundamental-mode' the semicolon of a comment is
not a comment and almost anything reads cleanly.  And `check-parens' must run,
because a plain read loop stops at the last complete form and signals
end-of-file, which looks like success."
  (with-temp-buffer
    (emacs-lisp-mode)
    (insert-file-contents file)
    (goto-char (point-min))
    (condition-case err
        (progn
          (check-parens)
          (condition-case nil
              (while (< (point) (point-max))
                (read (current-buffer)))
            (end-of-file nil))   ; trailing comment or newline, fine
          t)
      (error
       (message "READ ERROR %s: %s (at %d)"
                file (error-message-string err) (point))
       nil))))

(let* ((files (rl-check--files))
       (failed (seq-remove #'rl-check--reads-cleanly files)))
  (message "Checked %d files." (length files))
  (if failed
      (progn
        (message "FAILED (%d):" (length failed))
        (dolist (f failed) (message "  %s" f))
        (kill-emacs 1))
    (message "All files read cleanly.")))

;;; check-syntax.el ends here
