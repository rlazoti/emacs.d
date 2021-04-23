(use-package hydra
  :defer 2
  :bind ("C-c f" . hydra-flycheck/body))

(use-package major-mode-hydra
  :ensure t
  :after hydra
  :bind
  ("M-SPC" . major-mode-hydra))

(major-mode-hydra-define json-mode nil
  ("Pretty Print"
   (("b" json-pretty-print-buffer "buffer"))))

(defhydra hydra-flycheck (:color blue)
  "
  ^
  ^Flycheck^          ^Errors^            ^Checker^
  ^────────^──────────^──────^────────────^───────^─────
  _q_ quit            _<_ previous        _?_ describe
  _M_ manual          _>_ next            _d_ disable
  _v_ verify setup    _f_ check           _m_ mode
  ^^                  _l_ list            _s_ select
  ^^                  ^^                  ^^
  "
  ("q" nil)
  ("<" flycheck-previous-error :color pink)
  (">" flycheck-next-error :color pink)
  ("?" flycheck-describe-checker)
  ("M" flycheck-manual)
  ("d" flycheck-disable-checker)
  ("f" flycheck-buffer)
  ("l" flycheck-list-errors)
  ("m" flycheck-mode)
  ("s" flycheck-select-checker)
  ("v" flycheck-verify-setup))

(provide 'emacs-hydra)
