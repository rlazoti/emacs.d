(use-package go-mode
  :config
  (setq gopath (string-replace "//" "/" (car (split-string (getenv "GOPATH") ":"))))
  (add-to-list 'load-path (concat gopath "/src/golang.org/x/lint/misc/emacs/"))
  (require 'golint)
  (setq gofmt-command "goimports")
  (add-hook 'go-mode-hook #'lsp-deferred)
  (add-hook 'go-mode-hook (lambda () (add-hook 'before-save-hook 'gofmt-before-save)))
)

(use-package flycheck-golangci-lint
  :hook (go-mode . flycheck-golangci-lint-setup))

(use-package go-gen-test)

(use-package gotest)

(provide 'emacs-golang)
