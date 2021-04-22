(use-package counsel
  :ensure t
  :bind (:map global-map
              ("M-x" . counsel-M-x)
              ("C-c s" . swiper)
              ("C-c S" . swiper-all)
              :map ivy-minibuffer-map
              ("TAB" . ivy-alt-done)
              ("C-l" . ivy-alt-done)
              ("C-j" . ivy-next-line)
              ("C-k" . ivy-previous-line)
              :map ivy-switch-buffer-map
              ("C-k" . ivy-previous-line)
              ("C-l" . ivy-done)
              ("C-d" . ivy-switch-buffer-kill)
              :map ivy-reverse-i-search-map
              ("C-k" . ivy-previous-line)
              ("C-d" . ivy-reverse-i-search-kill))

  :config
  ;; double check this
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t)
  (setq ivy-initial-inputs-alist nil)
  (setq ivy-re-builders-alist
        '((read-file-name-internal . ivy--regex-fuzzy)
          (counsel-M-x . ivy--regex-fuzzy)
          (t . ivy--regex-plus)))

  :init
  (ivy-mode 1))

(use-package all-the-icons-ivy-rich
  :ensure t
  :after ivy-rich
  :init (all-the-icons-ivy-rich-mode 1)
  :config
  (setq all-the-icons-ivy-rich-icon-size 1.0)
  )

(use-package ivy-rich
  :ensure t
  :after counsel
  :init (ivy-rich-mode 1))

(provide 'emacs-ivy)
