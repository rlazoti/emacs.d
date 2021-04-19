(use-package counsel
  :ensure t
  :bind (:map global-map
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

;; (emacs-require-packages '(counsel flx))

;; (global-set-key (kbd "C-c s") 'swiper)
;; (global-set-key (kbd "C-c S") 'swiper-all)
;; (global-set-key (kbd "C-c C-r") 'ivy-resume)
;; (global-set-key (kbd "<f4>") 'ivy-resume)
;; (global-set-key (kbd "M-x") 'counsel-M-x)
;; (global-set-key (kbd "C-x C-f") 'counsel-find-file)
;; (global-set-key (kbd "<f1> f") 'counsel-describe-function)
;; (global-set-key (kbd "<f1> v") 'counsel-describe-variable)
;; (global-set-key (kbd "<f1> l") 'counsel-find-library)
;; (global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
;; (global-set-key (kbd "<f2> u") 'counsel-unicode-char)
;; (global-set-key (kbd "C-c g") 'counsel-git)
;; (global-set-key (kbd "C-c j") 'counsel-git-grep)
;; (global-set-key (kbd "C-c k") 'counsel-ag)
;; (global-set-key (kbd "C-x l") 'counsel-locate)
;; (global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
;; (define-key read-expression-map (kbd "C-r") 'counsel-expression-history)

(provide 'emacs-ivy)
