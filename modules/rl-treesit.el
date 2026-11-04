;;; rl-treesit.el --- tree-sitter grammar recipes and installer -*- lexical-binding: t; -*-
;;; Commentary:
;; Emacs 31 has tree-sitter support (this machine: libtree-sitter 0.27,
;; `treesit-available-p' is t) but ships NO grammar: on 2026-10-14
;; `treesit-language-available-p' returned nil for every language, and
;; `treesit-language-source-alist' was nil, so `M-x
;; treesit-install-language-grammar' had nothing to install from.
;;
;; This module defines the recipes for the languages this config uses and adds
;; one command that installs the missing ones.
;;
;; After the grammars are installed, Emacs 31 chooses the tree-sitter mode
;; through `treesit-enabled-modes': it fills `major-mode-remap-alist' from the
;; remaps the TS modes declare (ruby-mode -> ruby-ts-mode, sh-mode ->
;; bash-ts-mode, dockerfile-mode -> dockerfile-ts-mode, and so on), and a remap
;; is only installed when that grammar is available.  So a missing grammar
;; means the classic mode, not a broken buffer.
;;
;; Emacs 30 had a different mechanism, `treesit-auto' with its own recipe list;
;; Emacs 31 removed it.  Do not add `global-treesit-auto-mode' here: it does not
;; exist any more.
;;
;; Requirements of the installer: git and a C compiler.  Both are present.
;; Grammars are compiled into <config>/var/tree-sitter, which is set as
;; `treesit-extra-load-path' below so the directory stays inside the config
;; (and out of git, like the rest of var/).  That is also where Emacs would
;; install a grammar by itself, which this config turns off: one command,
;; `rl-treesit-install-missing', is the only thing that downloads.

;;; Code:

(require 'treesit)

(defconst rl-treesit-directory (expand-file-name "tree-sitter/" user-emacs-directory)
  "Directory holding the compiled grammar libraries.")

(progn
  (make-directory rl-treesit-directory t)
  (setq treesit-extra-load-path
        (cons rl-treesit-directory
              (delete rl-treesit-directory treesit-extra-load-path)))
  ;; t means "enable every TS mode whose grammar is installed", which is what
  ;; makes the fallback graceful: a language with no grammar keeps its classic
  ;; mode.  This option is what replaced Emacs 30's `treesit-auto'.
  ;;
  ;; `customize-set-variable', not `setq': the option's `:set' is what copies
  ;; the entries of `treesit-major-mode-remap-alist' into
  ;; `major-mode-remap-alist', and `setq' never calls `:set'.  With `setq' the
  ;; variable reads t and nothing happens, which is a confusing way to spend an
  ;; afternoon.
  (customize-set-variable 'treesit-enabled-modes t)
  ;; Never download a grammar as a side effect of visiting a file: grammars come
  ;; from `rl-treesit-install-missing', which is explicit about the network.
  (customize-set-variable 'treesit-auto-install-grammar nil))

;;; Recipe format, from the doc of `treesit-language-source-alist':
;;;   (LANG . (URL REVISION SOURCE-DIR CC C++ COMMIT))
;;; SOURCE-DIR is the directory that contains parser.c.  Emacs 31 ships this
;;; list empty, so every recipe is written here.
;; The four C-family recipes are written here even though `c-ts-mode.el' and
;; `cmake-ts-mode.el' add their own to this very variable: those files are
;; autoloaded, so on a cold start -- which is when `rl-treesit-install-missing'
;; runs -- their entries are not there yet and the installer would report "no
;; recipe".  The commits are the ones those two files ask for, because the
;; queries that drive indentation and Imenu are compiled into them against
;; exactly those grammars; a newer grammar can parse a file the queries no
;; longer match.
;;
;; `:commit' and not the positional REVISION: that slot is a branch or tag name
;; handed to `git clone -b', and a clone cannot check out a commit it was never
;; told about, so putting a hash there fails with "Remote branch <sha> not found
;; in upstream origin".  `:commit' takes the other branch of the installer, a
;; blobless clone followed by a checkout.
(setq treesit-language-source-alist
      '((bash       . ("https://github.com/tree-sitter/tree-sitter-bash"))
        (c          . ("https://github.com/tree-sitter/tree-sitter-c"
                       :commit "3aa2995549d5d8b26928e8d3fa2770fd4327414e"))
        (cmake      . ("https://github.com/uyha/tree-sitter-cmake"
                       :commit "e409ae33f00e04cde30f2bcffb979caf1a33562a"))
        (cpp        . ("https://github.com/tree-sitter/tree-sitter-cpp"
                       :commit "f41b4f66a42100be405f96bdc4ebc4a61095d3e8"))
        (css        . ("https://github.com/tree-sitter/tree-sitter-css" nil "src"))
        (dockerfile . ("https://github.com/camdencheek/tree-sitter-dockerfile" nil "src"))
        ;; Doc-comment highlighting in C and C++; optional, the classic mode is
        ;; used without it and only the comments look plainer.
        (doxygen    . ("https://github.com/tree-sitter-grammars/tree-sitter-doxygen"
                       :commit "1e28054cb5be80d5febac082706225e42eff14e6"))
        (go         . ("https://github.com/tree-sitter/tree-sitter-go"))
        (javascript . ("https://github.com/tree-sitter/tree-sitter-javascript"))
        (json       . ("https://github.com/tree-sitter/tree-sitter-json"))
        (lua        . ("https://github.com/tree-sitter-grammars/tree-sitter-lua" nil "src"))
        (python     . ("https://github.com/tree-sitter/tree-sitter-python"))
        (ruby       . ("https://github.com/tree-sitter/tree-sitter-ruby"))
        (rust       . ("https://github.com/tree-sitter/tree-sitter-rust"))
        (toml       . ("https://github.com/tree-sitter-grammars/tree-sitter-toml" nil "src"))
        ;; One repository, two grammars: each lives in its own subdirectory.
        (tsx        . ("https://github.com/tree-sitter/tree-sitter-typescript"
                       nil "tsx/src"))
        (typescript . ("https://github.com/tree-sitter/tree-sitter-typescript"
                       nil "typescript/src"))
        (yaml       . ("https://github.com/tree-sitter-grammars/tree-sitter-yaml"
                       nil "src"))))

(defgroup rl-treesit nil
  "Tree-sitter setup for this configuration."
  :group 'convenience
  :prefix "rl-treesit-")

(defcustom rl-treesit-languages
  '(bash c cmake cpp css dockerfile doxygen go javascript json python ruby rust
    toml tsx typescript yaml)
  "Languages this configuration installs grammars for.
Every entry needs a recipe in `treesit-language-source-alist'.  A language that
is not listed still works: its classic mode is used."
  :type '(repeat symbol)
  :group 'rl-treesit)

(defun rl-treesit-missing ()
  "Return the languages of `rl-treesit-languages' without a grammar."
  (seq-remove (lambda (lang) (ignore-errors (treesit-language-available-p lang)))
              rl-treesit-languages))

(defun rl-treesit-install-missing ()
  "Download and compile the grammar of every missing language."
  (interactive)
  (let ((missing (rl-treesit-missing)))
    (if (not missing)
        (message "All grammars are installed: %s" rl-treesit-languages)
      (dolist (lang missing)
        (message "Installing grammar for %s" lang)
        (condition-case err
            (treesit-install-language-grammar lang)
          (error
           (display-warning 'rl-treesit
                            (format "%s failed: %s" lang
                                    (error-message-string err))))))
      (message "Done. Missing now: %s" (rl-treesit-missing)))))

(provide 'rl-treesit)
;;; rl-treesit.el ends here
