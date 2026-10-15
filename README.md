Emacs configuration
===================

My GNU Emacs configuration, built on top of
[minimal-emacs.d](https://github.com/jamescherti/minimal-emacs.d).

- Emacs: 31.1 or newer.
- Package manager: `package.el`, plus `package-vc` for the private modules that
  install from Git.
- Licence: MIT for my files. `early-init.el`, `init.el` and `.LICENSE` are
  GPLv3 from minimal-emacs.d, copyright James Cherti.


Install
-------

    git clone <your-fork-url> ~/.emacs.d
    emacs                       # first start downloads every package

The first start installs the packages that the modules declare, so it takes a
while and prints progress in the echo area. Nothing else is needed.

To install without starting Emacs, then get the byte-compiled modules before
the first real start (startup is 2.0 s compiled, 7-12 s from source):

    cd ~/.emacs.d
    make install-deps
    make compile

To try it without replacing the current config:

    emacs --init-directory ~/Projects/emacs.d-new


Layout
------

    early-init.el          base configuration, never edit
    init.el                base configuration, never edit
    .LICENSE               base configuration (GPLv3 text for those two files)

    pre-early-init.el      mine: var/ redirection, minimal-emacs.d knobs
    post-early-init.el     mine: package archive notes
    pre-init.el            mine: load-path for modules/ and modules-private/
    post-init.el           mine: the list of modules to load, then the private loader

    modules/               PUBLIC modules, tracked by git
    modules-private/       PRIVATE modules, ignored by git
    modules-private.el     PRIVATE loader, ignored by git
    snippets/              my own yasnippet snippets (tracked)
    var/                   all generated state (ignored)
    custom.el              written by M-x customize (ignored)

`pre-early-init.el` moves `user-emacs-directory` to `var/`, so packages, the
native compilation cache, `recentf`, `saveplace`, `savehist`, bookmarks, undo
history and the Treemacs state all land in `var/`. The repository root stays
clean.


Public and private
------------------

Public (`modules/`): package selection, keybindings, editing defaults,
language modes. Anything that is true on any machine.

Private (`modules-private/`, `modules-private.el`): names, e-mail addresses,
absolute paths outside this repository, employer projects and tooling,
downloaded CLI paths, anything with a secret.

The private loader runs last, so a private file can override any public default
without editing the public file. Example: the public `rl-lang-ruby.el` sets up
Ruby editing, and the private `rl-ruby-work.el` adds rbenv, RuboCop, Rails and
Yari.

Never move a private file into `modules/`. `.gitignore` ignores
`/modules-private/` and `/modules-private.el` (with `!.gitkeep` so the empty
directory survives).


After install
-------------

1. Icons for the mode line and Treemacs:

       M-x nerd-icons-install-fonts

2. tree-sitter grammars. Emacs 31 has tree-sitter but ships no grammar and an
   empty `treesit-language-source-alist`, so the `-ts` modes are inactive until
   the grammar is compiled. One command does them all:

       M-x rl-treesit-install-missing      # or: make grammars

   It needs `git` and a C compiler. Grammars are written to
   `var/tree-sitter/`, which `rl-treesit.el` puts on `treesit-extra-load-path`
   (and which `treesit-auto-install-grammar` is set to `nil`, so visiting a
   file never starts a download).

   The 13 languages are bash, css, dockerfile, go, javascript, json, python,
   ruby, rust, toml, tsx, typescript and yaml. With the grammars present,
   Emacs selects the TS mode by itself through `treesit-enabled-modes`; a
   language whose grammar is missing quietly keeps its classic mode. Emacs 30
   solved this with `treesit-auto`, which Emacs 31 removed — do not add it back.

   What that buys you, measured by visiting one file of each kind:

       a.rb → ruby-ts-mode      a.js → js-ts-mode        a.sh → bash-ts-mode
       a.py → python-ts-mode    a.ts → typescript-ts-mode
       a.yml → yaml-ts-mode     a.json → json-ts-mode    a.css → css-ts-mode
       a.toml → toml-ts-mode    a.go → go-ts-mode        a.rs → rust-ts-mode
       Dockerfile → dockerfile-ts-mode

   `a.html` stays in `web-mode` and `a.scss` in `scss-mode` on purpose: neither
   has a grammar here.

3. Language servers, installed outside Emacs:

       pyright          pip install pyright        (Python, via Eglot)
       ruby-lsp         gem install ruby-lsp       (Ruby)
       aspell           brew install aspell        (spell checking, present)
       rg               present, used by deadgrep and dumb-jump

4. Optional, if you want them:

       brew install pandoc        # markdown export and preview
       brew install git-delta     # then re-add the magit-delta package


Key chords
----------

Only the chords this config defines or changes. Everything else is the Emacs
default.

| Key           | Command                                        |
|---------------|------------------------------------------------|
| `ESC`         | quit any prompt or minibuffer                   |
| `C-x k`       | kill the current buffer                         |
| `C-c n`       | new untitled buffer                             |
| `C-l`         | go to a line, with preview (not `recenter`)     |
| `C-<up>`      | scroll one line down, point stays               |
| `C-<down>`    | scroll one line up, point stays                 |
| `C-c left`    | move to the window on the left (`windmove`)     |
| `C-c right`   | window right                                    |
| `C-c up`      | window up                                       |
| `C-c down`    | window down                                     |
| `C-z`         | undo one step (`undo-fu`)                       |
| `C-S-z`       | redo one step                                   |
| `C-M-z`       | redo everything back to the start               |
| `C-x C-z`     | suspend Emacs (the default `C-z` is taken)      |
| `C-+` / `C--` | text scale up / down                            |
| `M-u` `M-l` `M-c` | upcase, downcase, capitalize word           |
| `M-U` `M-L` `M-C` | upcase, downcase, capitalize region         |
| `C-c r`       | `replace-string`                                |
| `C-c C-s`     | search the region, else the thing at point      |
| `C-c a`       | `align-regexp`                                  |
| `C-c M-u`     | cycle the case style (snake/camel/camelCase)    |
| `M-up` `M-down` | move the line or region up / down              |
| `C->` `C-<`   | multiple cursors: mark next / previous like this |
| `C-c C->`     | multiple cursors: mark all like this            |
| `M-i` `M-n` `M-p` | symbol overlay: put, next, previous         |
| `C-;` or `S-SPC` | Embark actions on the thing at point         |
| `M-A`         | Marginalia annotator cycle                      |
| `M-TAB`       | complete at point (Corfu)                       |
| `C-c p p`     | completions at point (Cape prefix map)          |
| `C-x f`       | find file in project (Projectile)               |
| `s-p`         | Projectile command map                          |
| `C-S-s`       | deadgrep (project-wide ripgrep)                 |
| `M-s r`       | `consult-ripgrep` with preview                  |
| `M-s g` `M-s G` | `consult-grep`, `consult-git-grep`            |
| `M-s l`       | `consult-line` in the current buffer            |
| `M-g g`       | `consult-goto-line`                             |
| `M-g i`       | `consult-imenu`                                 |
| `M-g f`       | Flycheck errors, Consult style                  |
| `C-c f`       | Flycheck menu (transient)                       |
| `M-$`         | spell-correct word at point                     |
| `C-x g`       | Magit status                                    |
| `C-x M-g`     | Magit dispatch                                  |
| `C-c g l`     | `git-link` (copy the remote URL of this code)   |
| `C-c l r`     | rename symbol (Eglot)                           |
| `C-c l f`     | format buffer (Eglot)                           |
| `C-c l a`     | code actions (Eglot)                            |
| `C-c l j`     | find declaration (Eglot)                        |
| `M-s v`       | search workspace symbols (consult-eglot)        |
| `F5` / `F6`   | Treemacs refresh / show current project         |
| `F7` / `F8`   | run region / run file (quickrun)                |
| `F9`          | eshell                                          |
| `C-c l` `C-c c` `C-c g` | org store-link, capture, agenda         |

Private modules add their own chords; `C-h f <command>` finds them.


What is not here, and why
-------------------------

The audit of the previous configuration is in `AUDIT.md` in this repository
(2026-10-14), including what its checks found afterwards (section 7). The short
version:

| Removed | Reason |
|---------|--------|
| Ivy, Counsel, Swiper, ivy-rich | disabled in the old config but still installed; Vertico and Consult already replaced them |
| lsp-mode, lsp-ui, lsp-treemacs, lsp-docker, dap-mode, lsp-pyright | Eglot is built into Emacs 31 |
| company, company-box, company-quickhelp, company-web, company-terraform, company-inf-ruby, company-org-block | corfu + cape |
| hydra, major-mode-hydra, pretty-hydra, lv | `transient` is built in and Magit needs it anyway |
| all-the-icons, treemacs-all-the-icons | nerd-icons |
| nyan-mode, dimmer, centaur-tabs, mini-frame, popwin, fiplr, counsel-dash, counsel-css | candy, unmaintained, or Ivy only |
| git-gutter-fringe, fringe-helper, magit-delta | blamer and Magit cover it; the `delta` binary is not installed |
| undo-tree | frozen at 0.8.2; Emacs 28+ has non-linear undo with larger limits |
| pyvenv, pyvenv-auto, pyenv-mode, pythonic, robe | unmaintained and absent from the current package archives |
| json-mode | `.json` goes through the built-in `js-json-mode`, which Emacs 31 remaps to `json-ts-mode` once the grammar is installed |
| js2-mode, typescript-mode | Emacs 31 has js-ts-mode, tsx-ts-mode and typescript-ts-mode |
| markdown-preview-mode | pinned 2019 CDN assets; no converter installed |
| vterm and every AI assistant module | nothing used them any more; `vterm-module.so` was never built |
| golang, terraform CLI, docker client modules | `go`, `gopls`, `terraform` and `docker` are not installed |
| the org agenda, capture templates and org-wild-notifier | `~/Projects/docs/second-brain/Tasks` no longer exists |
| 25 lines of hand written ligature rules | see `modules/rl-font.el` |

Behaviour that changed on purpose:

- Trailing whitespace and trailing blank lines are removed on save
  (`stripspace`). The old config showed the whitespace but did not clean it.
- `C-l` still goes to a line. `recenter-top-bottom` is now only on `M-x`
  (it was unbound in the old config too).
- Undo is linear. There is no undo tree visualiser.
- Buffer position is restored when a file is reopened (`save-place-mode`).
- Files changed outside Emacs are re-read automatically
  (`global-auto-revert-mode`, already set by the base configuration).
- Line numbers, indent guides and hl-line are on in every buffer except Org,
  Magit, Dired, Treemacs, eshell and terminal buffers.


Maintenance
-----------

    make check-syntax   # read every .el file: parentheses, stray characters
    make check-load     # load the config; fail if any warning was raised
    make validate       # check every :custom / :custom-face name really exists
    make list-deps      # the packages the modules declare
    make install-deps   # install them without starting Emacs
    make compile        # byte-compile modules/ (big effect on startup, see below)
    make doctor         # what is missing: grammars, external programs, .elc files
    make startup        # time a real start, 3 runs
    make startup-load   # time the same Elisp in batch, no GUI frame
    make grammars       # compile the tree-sitter grammars that are missing
    make run            # start Emacs with this config, not ~/.emacs.d
    make run-debug      # same, with errors reported instead of caught

`check-load` exists because `use-package` turns a broken form into a warning and
Emacs starts anyway. A flycheck menu was broken that way for weeks: the suffix
order of `transient-define-prefix` was wrong, and the only evidence was a
warning nobody read.

`validate` exists because a `setq` of a name no package defines is legal Elisp
and does nothing. It checks 163 option names, and found nine that no longer
exist (`wgrep-change-on-exit`, `magit-clone-set-remote-HEAD`,
`undo-fu-session-compatible-modes`, `which-key-min-display-columns`,
`marginalia-annotator-registry`, `corfu-preview-action`,
`corfu-echo-documentation`, `eshell-continuation`,
`mac-emulate-three-button-mouse`).

Startup, measured on this machine (Emacs 31.1, ~60 packages):

    byte-compiled modules     2.0 s
    source only              7-12 s

So run `make compile` after a fresh checkout, and again after touching modules.
Native compilation of the modules (`batch-native-compile`) made no measurable
difference at 21 kB of Elisp, so the Makefile does not do it.

Two Emacs 31 details that cost time if you do not know them:

- `--batch` now implies `-q`: a batch run loads neither `early-init.el` nor
  `init.el`. Every target that needs the real config passes `--init-directory`
  and loads the two files by hand; `package-deps.el` and `validate-config.el`
  point `package.el` at `var/elpa` themselves for the same reason.
- `treesit-enabled-modes` must be changed with `customize-set-variable`, not
  `setq`: its `:set` is what copies the remaps into `major-mode-remap-alist`.
  With `setq` the variable reads `t` and nothing happens.
