;;; rl-completion.el --- Vertico, Consult, Orderless, Marginalia, Embark, Corfu, Cape -*- lexical-binding: t; -*-
;;; Commentary:
;; Ported and reduced from the old modules/emacs-vertico.el.
;;
;; Replacements:
;;   company + company-box + company-quickhelp + company-* backends
;;     -> corfu + cape + corfu-popupinfo
;;   ivy/counsel/swiper (disabled in the old config, still installed)
;;     -> vertico + consult + deadgrep
;;
;; `corfu-auto' stays nil on purpose: automatic completion polls language
;; servers on every keystroke, which costs time and parses untrusted code.
;; Use M-TAB (or the TAB key, since `tab-always-indent' is `complete').

;;; Code:

;;; Completion style (shared by Vertico, Corfu and every completion-at-point)
(use-package emacs
  :ensure nil
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-ignore-case t)
  (read-file-name-completion-ignore-case t)
  (read-buffer-completion-ignore-case t)
  ;; The old config searched fuzzily first, so keep that order.
  (orderless-matching-styles
   '(orderless-flex orderless-literal orderless-regexp orderless-initialism))
  ;; Do not offer commands that do not apply to the current buffer.
  (read-extended-command-predicate #'command-completion-default-include-p))

;;; Vertical completion in the minibuffer
(use-package vertico
  :custom
  (vertico-cycle t)
  (vertico-count 15)
  (vertico-resize t)
  :bind (:map minibuffer-local-map
              ("C-n" . vertico-next)
              ("C-p" . vertico-previous))
  :init (vertico-mode))

(use-package orderless
  :after vertico
  :init (require 'orderless))

(use-package marginalia
  ;; The annotator registry this config used to copy from an old dotfile is not
  ;; an option any more: `marginalia-annotators' holds the built-in table and
  ;; `M-A' cycles which annotator is used.
  :bind (("M-A" . marginalia-cycle)
         :map minibuffer-local-map
         ("M-A" . marginalia-cycle))
  :init (marginalia-mode))

;;; Consulting commands (buffer, line, grep, imenu, history...)
(use-package consult
  :bind (;; C-c bindings
         ("C-c h" . consult-history)
         ("C-c m" . consult-mode-command)
         ("C-c k" . consult-kmacro)
         ;; C-x bindings
         ("C-x M-:" . consult-complex-command)
         ("C-x b" . consult-buffer)
         ("C-x 4 b" . consult-buffer-other-window)
         ("C-x 5 b" . consult-buffer-other-frame)
         ("C-x r b" . consult-bookmark)
         ("C-x p b" . consult-project-buffer)
         ;; registers
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)
         ("C-M-#" . consult-register)
         ;; yank
         ("M-y" . consult-yank-pop)
         ;; goto
         ("M-g e" . consult-compile-error)
         ("M-g f" . consult-flycheck)
         ("M-g g" . consult-goto-line)
         ("M-g o" . consult-outline)
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; search
         ("M-s d" . consult-find)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s m" . consult-multi-occur)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)
         ("M-s e" . consult-isearch-history)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         :map minibuffer-local-map
         ("M-s" . consult-history)
         ("M-r" . consult-history))
  :hook (completion-list-mode . consult-preview-at-point-mode)
  :init
  (setq register-preview-delay 0.5
        xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)
  :config
  (advice-add #'register-preview :override #'consult-register-window)
  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep consult-man
   consult-bookmark consult-recent-file consult-xref
   :preview-key '(:debounce 0.4 any))
  (setq consult-narrow-key "<"))

;;; In-buffer completion
(use-package corfu
  :custom
  (corfu-cycle t)
  (corfu-count 12)
  (corfu-min-width 15)
  (corfu-max-width 60)
  (corfu-echo-delay 0)
  (corfu-auto nil)
  ;; Do not treat the text already in the buffer as a candidate, and do not
  ;; preselect the first candidate: Tab must complete, not insert.
  (corfu-preview-current nil)
  (corfu-preselect 'prompt)
  :init (global-corfu-mode))

;;; The documentation popup lives in corfu-popupinfo.el, another file of the
;;; same package, so it gets its own form: setting `corfu-popupinfo-delay'
;;; before that file loads would be overwritten by its own `defcustom'.
;;; `:ensure nil' because corfu-popupinfo is not a package: without it,
;;; `use-package' tries to install a package that no archive has.
(use-package corfu-popupinfo
  :ensure nil
  :after corfu
  :custom
  (corfu-popupinfo-delay '(0.2 . 0.1))
  (corfu-popupinfo-direction '(force-bottom))
  :config
  (corfu-popupinfo-mode 1))

(use-package cape
  :bind (("C-c p p" . completion-at-point)
         ("C-c p t" . complete-tag)
         ("C-c p d" . cape-dabbrev)
         ("C-c p f" . cape-file)
         ("C-c p k" . cape-keyword)
         ("C-c p s" . cape-symbol)
         ("C-c p e" . cape-elisp-block)
         ("C-c p w" . cape-dict))
  :init
  ;; Order: language server (added by eglot per buffer), then these.
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-elisp-block)
  (add-to-list 'completion-at-point-functions #'cape-keyword))

;;; Context actions
(use-package embark
  :bind (("C-;" . embark-act)
         ("S-SPC" . embark-act)
         :map minibuffer-local-map
         ("C-;" . embark-act))
  :custom (embark-help-key "?")
  :init (setq prefix-help-command #'embark-prefix-help-command))

(use-package embark-consult
  :after (embark consult)
  :hook (embark-collect-mode . consult-preview-at-point-mode))

(provide 'rl-completion)
;;; rl-completion.el ends here
