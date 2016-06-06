(defun customize-linum-mode ()
  (interactive)
  (set-face-attribute 'linum nil :background "gray7" :foreground "gray20"))

(add-hook 'linum-mode-hook 'customize-linum-mode)

(define-global-minor-mode custom-linum-mode linum-mode
  (lambda ()
    (when (not (memq major-mode
                     (list 'help-mode 'shell-mode 'speedbar-mode)))
      (linum-mode 1))))

(eval-after-load 'linum
  '(progn

     (defface linum-custom-face
       `((t :inherit 'linum :foreground "gray7" :background "gray7"))
       "Face for displaying INVISIBLE spaces for line numbers in display margin."
       :group 'linum)

     (defun linum-format-func (line)
       (let ((w (length (number-to-string (count-lines (point-min) (point-max))))))
         (concat
          (propertize "\u0020" 'face 'linum-custom-face)
          (propertize (make-string (- w (length (number-to-string line))) ?0) 'face 'linum-custom-face)
          (propertize (number-to-string line) 'face 'linum)
          (propertize "\u0020" 'face 'linum-custom-face))))

     (setq linum-format 'linum-format-func)))

(custom-linum-mode 1)

(provide 'emacs-linum)
