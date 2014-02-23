;;; mvn-autoloads.el --- automatically extracted autoloads
;;
;;; Code:


;;;### (autoloads (mvn-test mvn-clean mvn-compile mvn-last mvn mvn-kill-cache)
;;;;;;  "mvn" "mvn.el" (21257 17876 0 0))
;;; Generated autoloads from mvn.el

(autoload 'mvn-kill-cache "mvn" "\


\(fn)" t nil)

(autoload 'mvn "mvn" "\
Run mvn `task` in project root directory.

\(fn &optional TASK ARGS)" t nil)

(autoload 'mvn-last "mvn" "\
Run the last maven task in project

\(fn)" t nil)

(autoload 'mvn-compile "mvn" "\


\(fn)" t nil)

(autoload 'mvn-clean "mvn" "\


\(fn)" t nil)

(autoload 'mvn-test "mvn" "\


\(fn PREFIX)" t nil)

;;;***

;;;### (autoloads nil nil ("mvn-pkg.el") (21257 17876 503418 0))

;;;***

(provide 'mvn-autoloads)
;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; mvn-autoloads.el ends here
