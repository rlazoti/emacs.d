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
the first real start (1.81 s compiled, 1.77 s from source; see "Startup" at the
end of this file):

    cd ~/.emacs.d
    make install-deps
    make compile

To try it beside a config you are not ready to replace, point Emacs at the
checkout. `var/' is inside the configuration directory, so the packages that
checkout installs stay there too, including its `recentf', bookmarks and undo
history:

    git clone <your-fork-url> -b <branch> ~/Projects/emacs.d-new
    cd ~/Projects/emacs.d-new
    make install-deps
    make compile
    make doctor                     # what this machine is missing, and why it matters
    emacs --init-directory ~/Projects/emacs.d-new     # or: make run

Three things a checkout does not have, on purpose, and the config runs without
them: `custom.el` (whatever `M-x customize` has written), `modules-private.el`
and `modules-private/*.el` (identity, machine paths, employer tooling), and
`var/` (everything generated). The private layer is where your name and email
address live, so until it exists Magit guesses them from the system. `make
doctor` is the first command worth running on a new machine: it lists the
external programs, language servers and tree-sitter grammars this configuration
expects, each with what breaks without it, and it is the only place the language
servers are reported, because nothing inside Emacs notices their absence
otherwise.


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


History
-------

`main` is the branch to clone. Its history starts at the 2026-10-14 rewrite, so
`git log` stops there and shares nothing with the history of the configuration
it replaced. That one is kept on `archive/main-2026-02-12`, and
`master` and `old_version` are older snapshots. Nothing merges from any of them;
`AUDIT.md` is the bridge.


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

3. Language servers. Emacs 31 has Eglot and no server: Eglot starts a program
   that Emacs does not install and does not download. Two languages start a
   server by themselves here — Ruby and Python, the modes whose hooks carry
   `eglot-ensure` (see `modules/rl-lsp.el`) — so those are the two worth
   installing first:

       ruby-lsp    gem install ruby-lsp      (Ruby; `rbenv rehash' afterwards)
       pyright     pip install pyright       (Python; needs node, which is here)

   Every other language works with its plain major mode until you type `M-x
   eglot` in a project, and needs its server installed the same way:
   `typescript-language-server` for js/ts/tsx, `vscode-langservers-extracted`
   for json and css, `yaml-language-server`, `bash-language-server`, `tombi`
   for toml, `gopls`, `rust-analyzer`, `clangd`.

       make doctor

   prints one line per language: what `M-x eglot` would find on the PATH right
   now, which install won when two share a name (an rbenv shim is not a Homebrew
   binary), the command that adds the missing one, and whether that mode starts
   the server on its own. `aspell`, `rg` and the other non-server absences are in
   the same report, along with three things a buffer cannot show you: packages
   installed that nothing wants (both module layers count as callers, and a
   deleted `use-package` never uninstalls, so two are here inert), byte-code
   older than its source, and modes that are
   configured and never turned on — which is how `doom-modeline` sat for months
   with five settings that never ran.

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
| `C-c w l`     | wrap this buffer's long lines, or scroll again   |
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
| `C-c l d`     | diagnostics reported by the server (Flymake)    |
| `M-s v`       | search workspace symbols (consult-eglot)        |
| `F5` / `F6`   | Treemacs refresh / show current project         |
| `F7` / `F8`   | run region / run file (quickrun)                |
| `F9`          | eshell                                          |
| `C-c l` `C-c c` `C-c g` | org store-link, capture, agenda         |

Private modules add their own chords; `C-h f <command>` finds them.

Long lines wrap everywhere by default: `truncate-lines` is nil in `init.el`,
and `word-wrap t` makes the break land on whitespace. `C-c w l` flips it for
one buffer — a minified file, a one-line JSON blob or a log usually reads
better scrolled than folded. The same key also overrides the buffers that set
truncation on themselves (`ibuffer`, `occur`, anything from `tabulated-list`).

`C-c left/right/up/down` are the window chords, and `markdown-mode` and
`org-mode` also bind them (subtree edits, structural shifts). A mode map beats
the global map, so both are unbound in those two modes: the commands stay on
`S-left/right/up/down` in Org and on `C-c C--`, `C-c C-=` and `C-c C-x u/d/l/r`
in Markdown. Every other mode keeps its own `C-c <arrow>` bindings.


Who reports diagnostics
-----------------------

Eglot turns on Flymake in every buffer it manages and Flycheck is global, so on a
buffer with a server both engines report: two fringe marker sets and two error
lists, of which `M-g f`, `M-g F` and `C-c f` read only the Flycheck one. One of
the two is therefore turned off per language instead.

- Ruby keeps Flycheck. RuboCop is the Ruby linter of record, and the private
  module formats with it.
- Python hands diagnostics to the server. Flycheck's only Python checker here is
  `py_compile`, which reports syntax and nothing else.

Each choice is one function call in the language module, and `rl-lsp.el` holds
both options with the reasoning. A buffer with no server is not managed by Eglot,
so it keeps Flycheck either way, and the choice only ever gives up an engine that
is not running. Where the server reports, `C-c l d` is the error list (`M-g f`
is Flycheck's).

The other fringe question is independent of that and has no conflict in it:
`diff-hl` marks the lines `git diff` would show in the **left** fringe
(`diff-hl-side`), where nothing else lives, while both diagnostics engines use the
right one. It is on in `prog-mode` and `text-mode` buffers, skipped in data files
whose diffs are usually somebody else's (`json-ts-mode`, `yaml-ts-mode`, TOML), and
it updates on save rather than while typing. `M-x diff-hl-revert-hunk` undoes one
hunk at a time from the fringe, which is the reason to have the marks beyond
glancing at them.


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
| magit-delta | the `delta` binary is not installed, and the face hacks were fragile across Magit upgrades |
| git-gutter-fringe, fringe-helper | replaced by `diff-hl` a few weeks later: the reason recorded here (blamer and Magit cover it) answered a different question, see `rl-git.el` |
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
- Flycheck checks the first programming buffer rather than the first second of
  the session; Blamer appears half a second after the frame rather than during
  it. Both are in the table under "Where the time went".


Maintenance
-----------

    make check-syntax   # read every .el file: parentheses, stray characters
    make check-load     # load the config; fail if any warning was raised
    make validate       # check every :custom / :custom-face name really exists
    make list-deps      # the packages the modules declare
    make install-deps   # install them without starting Emacs
    make compile        # byte-compile modules/ (for its warnings, not speed)
    make elpa-elc       # make package byte-code newer than its source again
    make doctor         # what is missing: servers, grammars, programs, packages
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
and does nothing. It checks 165 option names, and found nine that no longer
exist (`wgrep-change-on-exit`, `magit-clone-set-remote-HEAD`,
`undo-fu-session-compatible-modes`, `which-key-min-display-columns`,
`marginalia-annotator-registry`, `corfu-preview-action`,
`corfu-echo-documentation`, `eshell-continuation`,
`mac-emulate-three-button-mouse`).

Startup, measured on this machine (Emacs 31.1, 84 packages installed, `make
startup`, which is a real frame in a pseudo terminal):

    now, byte-compiled modules        1.81 s
    now, from source (no .elc)        1.77 s
    without the mode line (below)     1.67 s
    before `make elpa-elc' (below)    1.90 s
    before the deferrals (below)      3.15 s
    batch load of both init files     1.05 s

Byte-compiling *my* modules is the top pair: 1.81 s against 1.77 s over four
alternating pairs, and 1.674 against 1.679 before the mode line went in. Source
was marginally quicker both times and the ordering does not hold from run to run,
so this is noise, and not the 5x this file used to claim. What was expensive was
never the 21 kB of my Elisp, it was the packages loading it pulled in — so
`make compile` stays worth running after a checkout for the warnings it produces,
not for speed, and the earlier "7-12 s from source" was measuring something else
(it does not reproduce).

The 1.90 s to 1.67 s step is `make elpa-elc` — both figures with the mode line
still dead, so the size of that win is unchanged by it. Worth explaining because
it was invisible from inside Emacs. `package.el` unpacks a tarball whose `.el` and
`.elc` were written in the same second, and here 108 of 316 libraries came out
with the source a few milliseconds *newer* than the byte-code beside it. `load`
reads a newer source as "the byte-code is stale": it uses the source instead,
compiles it, and prints whatever the compiler says about code nobody here owns.
That is where

    var/elpa/blamer-20251001.620/blamer.el: Warning: `when-let' is an obsolete
    macro (as of 31.1); use `when-let*' or `and-let*' instead.

came from, on every start, for packages that were fine. `vertico.el` and
`corfu-popupinfo.el` were two of the libraries loaded at startup this way.
`make doctor` counts them, and `make elpa-elc` (or `M-x rl-doctor-fix-byte-code`)
makes the timestamps agree — it recompiles nothing, so the native-compilation
cache stays valid and upstream's source is not touched. Installing or upgrading
packages puts the timestamps out of order again, so `make install-deps` runs it.

Native compilation of the modules (`batch-native-compile`) made no measurable
difference, so the Makefile does not do it.

### The mode line is a choice, and it costs 155 ms

`doom-modeline` is 155 ms of the 1.81 s, all of it `nerd-icons`: the package and
enabling the mode together measured zero. It is worth naming because it was
invisible the other way round. The form used to say `:after nerd-icons`, which
defers everything in the form including `:init`; nothing loaded `nerd-icons`, so
the mode never started and the five `:custom` settings under it did nothing, with
no error to say so. It now says `:demand t` with the mode enabled in `:config`
(which is also the order `use-package` expands to: `:custom` before the
`require`), and `make doctor` reports whether `doom-modeline-mode` is on, so the
failure mode stays visible. Its icons need a nerd font, already here as
`~/Library/Fonts/NFM.ttf`; `M-x nerd-icons-install-fonts` is the command if a
glyph ever shows as a box. If you would rather have Emacs's plain mode line,
deleting that form is 155 ms and the numbers above are the whole argument.

### Where the time went, and what moved

Attribution was done by wrapping the `require` calls of `post-init.el` in
`float-time` and starting a real frame once — the four heaviest modules were
`rl-git` 421 ms, `rl-check` 419 ms, `rl-web` 323 ms, `rl-markdown` 311 ms of a
2.4 s init. Deferring what has an autoload got 1.28 s back:

| Change | Cost at startup | Why it is safe |
|--------|-----------------|----------------|
| `blamer` starts from a 0.5 s idle timer | 350 ms | blamer.el pulls Magit in; the globalized minor mode covers every buffer whenever it is turned on, and Blamer waits `blamer-idle-time` (2 s) before drawing anything |
| `flycheck` on `prog`/`text`/`conf` hooks instead of `global-flycheck-mode` at init | ~350 ms | its own per-buffer predicate only ever enabled it where a checker exists; same three mode families `stripspace` and `indent-bars` use |
| `ediff`, `css-mode`, `mermaid-mode` marked `:defer t` | ~350 ms together | each only carries `:custom`/`face` settings that nothing reads before the mode runs, and all three are autoloaded by `package.el` |

The measurement, not the table, is the part to keep: a first pass "proved"
`exec-path-from-shell` cost 1.37 s, which turned out to be a broken patch that
made init exit early (it is 150 ms), and timing every `require` with advice more
than doubled the init it was measuring. Two Emacs facts make the rest of it
workable: `--eval` on the command line runs *after* init, so that is where
measurement code goes, and a run that never reaches the command loop runs no
idle timers at all, so a timer-driven change cannot be verified headlessly.

Two Emacs 31 details that cost time if you do not know them:

- `--batch` now implies `-q`: a batch run loads neither `early-init.el` nor
  `init.el`. Every target that needs the real config passes `--init-directory`
  and loads the two files by hand; `package-deps.el` and `validate-config.el`
  point `package.el` at `var/elpa` themselves for the same reason.
- `treesit-enabled-modes` must be changed with `customize-set-variable`, not
  `setq`: its `:set` is what copies the remaps into `major-mode-remap-alist`.
  With `setq` the variable reads `t` and nothing happens.
