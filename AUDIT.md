# Config audit — 2026-10-14

Scan of `~/.emacs.d` (branch `main`, last commit 2026-02-08, working tree dirty).
This file is a working document for the rewrite. Delete it when the migration is done.

## 1. Measured facts

| Item | Value |
|---|---|
| Emacs | 31.1 (`/usr/local/bin/emacs`), native compilation available |
| Startup time (`emacs -nw`, 3 runs) | **13.7s – 14.4s** |
| Baseline startup (`emacs -Q -nw`) | **0.12s** |
| Installed packages (`packages/`) | 145 directories, 88 MB |
| `eln-cache/` | 268 MB |
| `.cache/` | 67 MB |
| `eca/` (untracked) | 114 MB (86 MB binary + 33 MB zip) |
| Modules (`modules/`) | 57 files, 1885 lines |
| Modules loaded from `emacs-modules.el` | 51 |
| Modules commented out in `emacs-modules.el` | 6 (`shadowenv`, `flipper`, `golang`, `ivy`, `mini-frame`, `tabs`) |
| Module files never required by anything | `emacs-fiplr.el`, `emacs-gnu-elpa.el` |
| Module that is empty except `provide` | `emacs-outline-indent.el` (all code commented) |
| Tracked files in git | 65 |
| Private layer | `modules-private/` exists but is empty; `emacs-modules-private.el` does not exist |

The 14 second startup is the main reason to rewrite. `emacs -Q` costs 0.12s, so the
cost is in the config, not in Emacs.

## 2. Problems found

### 2.1 Dead code (loads nothing, or is never loaded)

- `modules/emacs-fiplr.el` — never required. Same job as `projectile-find-file`, which is bound.
- `modules/emacs-gnu-elpa.el` — never required. It sets `epg-gpg-program` and updates the ELPA keyring.
- `modules/emacs-outline-indent.el` — required, but 100% commented out.
- `modules/emacs-ivy.el` — disabled, but `ivy`, `counsel`, `swiper`, `all-the-icons-ivy-rich`,
  `ivy-rich` are still installed (28 MB+ of the 88 MB).
- `terminal/init.el` — a second, separate config. Nothing loads it. It duplicates `emacs-core.el`.
- `snippets/` and `savefile/` — empty directories.
- `packages/undo-tree-0.8.2`, `robe-0.8.6` — pinned old versions, see 2.4.

### 2.2 Enabled modules that depend on the disabled Ivy stack

These three modules are active and pull Ivy back in:

- `emacs-docset.el` → `counsel-dash` (needs Ivy, unmaintained, needs `~/.docsets`)
- `emacs-flyspell.el` → `flyspell-correct-ivy`
- `emacs-web.el` → `counsel-css`

### 2.3 Installed packages with no configuration anywhere

- `gptel` — installed (commit "Add gptel support"), no `use-package` form references it.
- `nerd-icons` — installed, nothing uses it. `all-the-icons` is the one in use.
- `ace-window`, `avy` — no reference. `avy` is a dependency of `swiper`; `ace-window` looks like an orphan.

### 2.4 Packages that are stale, unmaintained, or replaced by built-ins

Version strings are the build dates from `packages/`.

| Package | Build date | Status | Modern replacement |
|---|---|---|---|
| `ivy` / `counsel` / `swiper` | 2026-04 | already disabled, still installed | `vertico` / `consult` (already present) |
| `undo-tree` | 0.8.2 (pinned) | author stopped development; Emacs 28+ has non-linear undo and configurable undo limits, which `the base configuration` already sets | built-in undo, or `undo-fu` + `undo-fu-session` (what the base configuration recommends) |
| `lsp-mode` + `lsp-ui` + `lsp-treemacs` + `lsp-docker` + `dap-mode` | 2026-04 | works, heavy | `eglot` (built-in, `eglot` 1.x ships in Emacs 31), `consult-eglot`, `eglot-x` if needed |
| `pyvenv` (2021) + `pyvenv-auto` + `pyenv-mode` + `pythonic` | 2021–2023 | `pyvenv` is unmaintained | `venv` (GNU ELPA) or `pythonvenv`, plus `eglot` |
| `robe` | 0.8.6 | needs the old `static analyzer`; nothing enables `robe-mode` | `dumb-jump` (already present) or Eglot |
| `markdown-preview-mode` | 2023-07 | config points at highlight.js **9.15.6** and github-markdown-css **3.0.1** CDN assets from 2019 | `markdown-mode` export, or `glow`/`vmd` in `vterm` |
| `dimmer` | 2022-08 | single-face hack, no maintenance | drop, or `highlight-focused`-style face trick |
| `hydra` + `major-mode-hydra` + `pretty-hydra` + `lv` | 2025-03 | superseded | `transient` (built-in, already installed as a Magit dependency) |
| `centaur-tabs` | disabled | Emacs has `tab-bar` since 27 | built-in `tab-bar` |
| `popwin` | 2026-01 (fork) | overlaps `display-buffer-alist` | keep, or use `display-buffer` rules |
| `all-the-icons` | 2025-05 | needs font download, pulls `ht`, `dash` | `nerd-icons` (already installed, lighter) |
| `which-key` | not installed in this dir, config calls it | Emacs 31 has no built-in which-key | keep `which-key`, or `which-key` v4 |
| `flycheck-pos-tip` + `pos-tip` | 2020 | `pos-tip` is C-level and old | `flycheck` + `flycheck-popup-tip` or `consult-flycheck` |
| `company-quickhelp` | 2023 | needs `posframe` | `corfu` + `corfu-popupinfo`, or `lsp-ui-doc` |
| `exec-path-from-shell` | 2026-04 | maintained, the base configuration recommends it | keep |
| `projectile` | 2026-04 | maintained, overlaps `project.el` | keep, or move to `project.el` + `consult-project-buffer` |

### 2.5 Broken external tool dependencies

The module exists and loads, but the binary it needs is missing from the PATH available to
this shell. Verify in your login shell with `command -v <name>`.

| Binary | Needed by | Result |
|---|---|---|
| `delta` | `magit-delta-mode` (enabled by hook) | Magit diff rendering fails or falls back |
| `multimarkdown` | `emacs-markdown.el` sets `markdown-command "multimarkdown"` | `C-c C-c C-c` preview/export fails |
| `ag` | `emacs-search.el` (that block is commented) | none |
| `go`, `gopls`, `golint` | `emacs-golang.el` (module disabled) | none |
| `terraform` | `emacs-terraform.el` (module enabled) | no format/complete backend |
| `docker` | `emacs-docker.el` (module enabled) | `M-x docker` fails |
| `pyright` | `emacs-python.el` | `lsp-pyright` installs it on first use via pip/npm |
| `vterm-module.so` | `vterm` | not built; `vterm` compiles it on first use, needs `cmake` + a C compiler |

Present and working: `rg`, `git`, `aspell`, `pygmentize`, `rbenv`, `rubocop`, `bundle`,
`ruby`, `node`, `npm`, `python3`, `tmux`, `jq`.

### 2.6 Config that references paths that do not exist

`modules/emacs-org.el` points at `~/Projects/docs/second-brain/Tasks`. That directory is
gone. It is used by `org-agenda-files`, `org-archive-location`, and all four capture
templates. The agenda and capture are therefore broken now.

### 2.7 Init hygiene problems

- No `custom-file`. The Custom menu writes into `init.el`. The uncommitted diff in
  `init.el` shows this happening: `package-selected-packages`,
  `safe-local-variable-values`, and `safe-local-variable-directories` were rewritten there.
- `modules/emacs-osx.el` and `modules/emacs-gnu-elpa.el` call `custom-set-variables`
  inside a module. Same problem: it writes to `init.el`.
- `init.el` sets `package-native-compile`. In Emacs 31.1 that variable is **unbound**
  (`(boundp 'package-native-compile)` → nil), so it does nothing.
- `init.el` sets `native-comp-deferred-compilation`. That name is obsolete; the current
  name is `native-comp-jit-compilation`.
- `emacs-core.el` sets `mouse-wheel-scroll-amount` twice, with different values. Only the
  second one (in the `hscroll-margin` block) survives.
- `emacs-core.el` uses `(set 'ad-redefinition-action 'accept)`. That advice variable is gone
  from modern Emacs. `setq`, not `set`.
- `emacs-editor.el` has `(setq-default indent-line-function 2)`. `indent-line-function`
  must be a function. This is a bug; the value is ignored by most modes.
- `emacs-editor.el` uses `setq-default` on variables that may not exist
  (`highlight-tabs`, `view-read-only`, `fringes-outside-margins`). `setq-default` creates
  the variable silently, so a typo has no effect and no warning.
- `(global-set-key (kbd "C-z") #'undo)` plus `global-undo-tree-mode` — two undo systems.
- `marmalade` archive: the repo is dead upstream. Already commented out. Good.
- `.gitignore` does not cover `eca/`, `org-persist/`, `.dap-breakpoints`, `var/`
  as a rule (it has `var`, but no trailing pattern for cache dirs). Risk: `eca/` adds
  114 MB to the repo on the next `git add .`.

### 2.8 Work-specific content that is currently in the public repo

- `modules/emacs-core.el`: `user-mail-address "rodrigolazoti@gmail.com"`.
- `modules/emacs-ai.el`: `claude-code-ide-cli-path "~/.bin/dcx"`.
- `modules/emacs-org.el`: personal agenda and capture paths.
- Deleted in the uncommitted diff of `init.el`: `safe-local-variable-directories` with an
  employer project path, and `safe-local-variable-values` with `sorbet-ls` / `ruby-lsp-ls`
  settings. `modules/emacs-shadowenv.el` (disabled) and `modules/emacs-ruby.el`
  (`projectile-rails`, `rubocopfmt`, `yari`) are the same category.

These belong in the private layer.

## 3. Reuse decision per module

Legend:
- **PORT** — copy as is, small cleanups.
- **MODERNIZE** — keep the behaviour, change the package or the API.
- **PRIVATE** — move to the git-ignored layer (personal paths, work tooling).
- **DROP** — delete.

| Module | Lines | Decision | Notes |
|---|---|---|---|
| `emacs-core.el` | 88 | PORT + PRIVATE | Identity (`user-mail-address`) to private. Fix the two `set`, the double mouse var. Most settings now come from `the base configuration` already: `inhibit-splash-screen`, `make-backup-files`, `create-lockfiles`, `confirm-kill-emacs`, `yes-or-no-p`, `read-answer-short`. |
| `emacs-editor.el` | 166 | PORT | This is the highest value file: keybindings (`C-c arrows` windmove, `C-l` goto-line, `C-c a` align-regexp, upcase/downcase/capitalize), coding systems, PT-br input (`ns-right-alternate-modifier`), backup/autosave in tmp, `next-code-buffer`/`previous-code-buffer`. Remove the broken `indent-line-function 2`. `goto-line-preview`, `string-inflection`, `editorconfig` are all current. `formatted-copy` needs `pygmentize` (present). |
| `emacs-font.el` | 36 | MODERNIZE | Keep the font and the Apple symbol/emoji fallbacks. Replace the 25 line hand written `composition-function-table` ligature table with the `ligature` package, or with `prettify-symbols`. The hand table breaks on Emacs font changes and costs startup. |
| `emacs-theme.el` | 22 | PORT | `doom-themes` + `doom-one`. Keep. `doom-themes-treemacs-config` needs the icon set you choose. |
| `emacs-osx.el` | 17 | PORT | Modifier keys, `dired-use-ls-dired nil`. Move the `custom-set-variables` call out. |
| `emacs-vertico.el` | 183 | PORT, SHRINK | This is the modern stack already: `vertico`, `orderless`, `marginalia`, `consult`, `savehist`. Move `savehist`/`recentf`/`saveplace` to `pre-init.el` (the base configuration may already set them). Drop the duplicated `completion-category-overrides nil`. Keep your `orderless` styles. Add `embark`. |
| `emacs-company.el` | 61 | DECIDE | See question. `company-box` + `all-the-icons` icon table is 40 lines of icon mapping. Option: `corfu` + `cape` (the base configuration default). Option: keep `company` and switch `company-box` icons to `nerd-icons`. |
| `emacs-lsp.el` | 29 | DECIDE | `lsp-mode`/`lsp-ui`/`dap-mode` vs built-in `eglot`. `emacs-python.el` also starts LSP, so two modules load `lsp-mode`. |
| `emacs-dumb-jump.el` | 7 | PORT | Keep as xref fallback. |
| `emacs-projectile.el` | 13 | DECIDE | Keep, or move to `project.el`. `treemacs-projectile` follows this choice. |
| `emacs-search.el` | 27 | PORT | Keep `deadgrep` (uses `rg`, present). Delete the commented `ag`/`wgrep-ag` block. Consider `consult-ripgrep` + `wgrep`. |
| `emacs-git.el` | 37 | PORT | `magit`, `browse-at-remote`, `git-link`, `ediff` window setup. Fix `magit-delta` (needs the `delta` binary) or drop it. The face tweaks + `seq-difference` hook hack are fragile; test them with the current `magit-delta`. |
| `emacs-blamer.el` | 32 | PORT | Uses `browse-at-remote--commit-url` (an internal function, `--`). Risky across upgrades. Keep or replace with `magit-blame` / `git-messenger`. |
| `emacs-git-gutter-fringe.el` | 15 | DECIDE | Three margin/blame systems overlap: `git-gutter-fringe`, `blamer`, `magit-delta`. Pick two. Also `git-gutter` has built-in fringe bitmaps now; `fringe-helper` is not needed. |
| `emacs-git-timemachine.el` | 4 | PORT | One line. Merge into the git module. |
| `emacs-modeline.el` | 21 | MODERNIZE | `doom-modeline` + `minions` + `nyan` + `all-the-icons`. `nyan-mode` and `all-the-icons` are the heavy parts. Options: `doom-modeline` + `minions` with `nerd-icons`, or built-in modeline + `minions`. |
| `emacs-file-explorer.el` | 75 | PORT | `treemacs` config is good and current. Fix `treemacs-collapse-dirs` (needs Python), and the `f6` binding (`treemacs-add-and-display-current-project-exclusively`). Pick one icon theme. |
| `emacs-flycheck.el` | 53 | MODERNIZE | Custom fringe bitmaps are nice but `flycheck` ships good ones. `flycheck-pos-tip`/`pos-tip` → drop. Note the `:after exec-path-from-shell` coupling. Consider `flycheck` + `consult-flycheck` or `flymake` (built-in in 31). |
| `emacs-flyspell.el` | 26 | MODERNIZE | Replace `flyspell-correct-ivy` with `flyspell-correct` + `consult`, or `consult-isearch`-style flow. `aspell` is installed. Use the the base configuration flyspell/aspell article settings to cut false positives in code. |
| `emacs-todo.el` | 27 | PORT | `hl-todo` keyword list. Keep. |
| `emacs-whitespace.el` | 15 | PORT | Custom global minor mode with mode exclusions. Keep, but `whitespace-line-column` 120 vs `fill-column`; the base configuration sets `whitespace-line-column nil`. Decide: keep 120 explicitly. |
| `emacs-untabify.el` | 15 | DROP or KEEP | `indent-tabs-mode nil` is already the default in `emacs-editor.el`. Untabifying on save is aggressive for `Makefile`, Go, and pasted tabs; the guard list is short. |
| `emacs-smartparens.el` | 5 | DECIDE | `smartparens-global-mode` vs built-in `electric-pair-mode` + `Manipulate parens` commands. Both add 1 package or 0. |
| `emacs-multiple-cursors.el` | 11 | PORT | Keep the bindings. Emacs 31 also has built-in `multi-line`/`string-rectangle`; MC is still the best. |
| `emacs-drag-stuff.el` | 9 | PORT | Small, works. |
| `emacs-buffer-move.el` | 9 | PORT | Small, works. Consider `windmove` + `window-selection` instead. |
| `emacs-highlight-symbol.el` | 8 | PORT | `symbol-overlay`. Keep. |
| `emacs-indent-guide.el` | 8 | DECIDE | `highlight-indent-guides` (2026 build, still maintained) vs `indent-bars` (tree-sitter aware, faster). |
| `emacs-dimmer.el` | 7 | DROP | Unmaintained since 2022. |
| `emacs-popwin.el` | 11 | DECIDE | The five buffer patterns are useful. `display-buffer-alist` does the same with no dependency, and `the base configuration` already sets window rules. |
| `emacs-mini-frame.el` | 10 | DROP | Already disabled. Mini frame conflicts with Vertico in most setups. |
| `emacs-tabs.el` | 60 | DROP | Already disabled. Use built-in `tab-bar` if you want tabs. |
| `emacs-hydra.el` | 53 | MODERNIZE | Rewrite the flycheck and per-mode menus with `transient` (built-in). Delete the four `with-*icon` helpers (they exist only for `major-mode-hydra`). |
| `emacs-which-key.el` | 6 | PORT | Keep. |
| `emacs-yasnippet.el` | 11 | PORT | `snippets/` is empty, so only `yasnippet-snippets` is in use. Add your own snippets or drop the dir. |
| `emacs-run-file.el` | 14 | PORT | `exec-path-from-shell` (keep, the base configuration recommends it) + `quickrun` on F7/F8. Note `F9` is `eshell` in `emacs-core.el`; the README says F9 is "interactive shell". Docs and keys disagree. |
| `emacs-org.el` | 121 | PORT + PRIVATE | Keep: todo keywords, priorities, `org-modern` faces, capture structure, `org-log-done`. Fix: the four capture targets and `org-agenda-files` point to a path that does not exist. Move the paths to the private layer. `org-wild-notifier` (2026 build) uses `alert`/`libnotify` on macOS — verify it works. `company-org-block` depends on the completion decision. |
| `emacs-markdown.el` | 46 | MODERNIZE | Keep `markdown-mode` and the heading move bindings. Replace `markdown-preview-mode` (2019 CDN pins) and `markdown-command "multimarkdown"` (binary absent). `mermaid-mode` keep. |
| `emacs-web.el` | 41 | PORT, SHRINK | `web-mode` mode alist and indent settings: keep. Drop `counsel-css` (Ivy) and `company-web` if you move to Corfu. `emmet-mode` keep. `scss-mode` (2018) is fine, or built-in `scss-mode`... it is a package; check. |
| `emacs-javascript.el` | 8 | MODERNIZE | `js2-mode` + `add-hook 'js-mode-hook 'js2-minor-mode` is contradictory. Emacs 31 has built-in `js-ts-mode`/`tsx-ts-mode` (tree-sitter). Decide: tree-sitter modes, or `js2-mode`, not both. |
| `emacs-typescript.el` | 10 | MODERNIZE | `typescript-tsx-mode` derived mode is unnecessary in Emacs 31 (`tsx-ts-mode` built-in). `ts-comint` keep only if you use it. |
| `emacs-json.el` | 4 | PORT | One line. Note the `auto-mode-alist` entry also matches `.js` files as `json-mode`; that is wrong for plain JS. |
| `emacs-yaml.el` | 8 | PORT | Consider `outline-minor-mode` instead. |
| `emacs-ruby.el` | 91 | PORT + PRIVATE | Keep `ruby-mode` auto/interpreter mapping, `ruby-insert-encoding-magic-comment nil`, `inf-ruby`, `rspec-mode`, `minitest`. Move to private: `rbenv`, `rubocop`, `rubocopfmt`, `projectile-rails`, `yari`, the `bundle exec` flycheck wrapper. Drop `ruby-end` (mostly solved by `electric-pair`/`smartparens`) and `robe` (never enabled, stale). |
| `emacs-python.el` | 20 | MODERNIZE | Newest module, untracked. Replace `pyvenv-auto` + `lsp-pyright` with `venv`/`pythonvenv` + `eglot` (pyright binary absent; Eglot will prompt to install it). |
| `emacs-golang.el` | 18 | DROP | Disabled, `go`/`gopls` absent, and `golint` was deprecated upstream years ago. |
| `emacs-terraform.el` | 7 | DECIDE | Keep `terraform-mode` for editing; drop `company-terraform` if you move to Corfu. `terraform` binary absent. |
| `emacs-docker.el` | 10 | PORT, SHRINK | `dockerfile-mode`, `docker-compose-mode`; drop `docker.el` if the `docker` CLI is absent. |
| `emacs-graphql.el` | 3 | PORT | One line. Merge into a "web/text" module. |
| `emacs-sh-script.el` | 4 | PORT | One line: chmod on save for shebang files. |
| `emacs-shadowenv.el` | 7 | PRIVATE | Disabled, and it is employer specific. |
| `emacs-docset.el` | 24 | DROP | `counsel-dash` is Ivy-only and stale, `~/.docsets` is not in the repo. |
| `emacs-ivy.el` | 38 | DROP | Already disabled. |
| `emacs-fiplr.el` | 9 | DROP | Never loaded. |
| `emacs-gnu-elpa.el` | 7 | PORT | Never loaded. Move `gnu-elpa-keyring-update` and `epg-gpg-program` to `pre-init.el` or a private machine file. |
| `emacs-outline-indent.el` | 10 | DROP | Empty. |
| `emacs-ai.el` | 40 | PORT + PRIVATE | `vterm` settings: public. `claude-code-ide-cli-path "~/.bin/dcx"`, and which assistant you run: private. Decide which of `claude-code-ide`, `aidermacs`, `eca`, `gptel` stay. `eca` downloads a 114 MB `eca/` dir into the config root — that must be git-ignored, and the `:rev :newest` VC install does not belong in a fast startup path. |
| `init.el` | 101 | REPLACE | Replaced by `the base configuration` `early-init.el` + `init.el` + your `pre-init.el` / `post-init.el`. |
| `terminal/init.el` | 26 | DROP | Duplicates `emacs-core.el`. |

## 4. Proposed target layout

```
~/.emacs.d/                      git repo, public
  early-init.el                  base configuration (never edit)
  init.el                        base configuration (never edit)
  pre-early-init.el              yours: UI features, gc, var/ redirection
  post-early-init.el             yours: package archives, package-vc setup
  pre-init.el                    yours: load-path for modules/, var/ paths
  post-init.el                   yours: (require 'rl-modules) then private loader
  modules/                       PUBLIC modules   (tracked)
    rl-core.el  rl-editor.el  rl-keys.el  rl-completion.el  rl-ui.el
    rl-git.el  rl-search.el  rl-org.el  rl-web.el  rl-ruby.el ...
  modules-private/               PRIVATE modules  (git-ignored)
    rl-work.el                   employer tooling, project paths
    rl-ai-local.el               CLI paths, model names
    rl-identity.el               user-mail-address, signature
  modules-private.el             git-ignored loader; missing file = no error
  var/                           all generated state (git-ignored)
    var/elpa var/eln-cache var/cache var/recentf var/custom.el
  snippets/                      your own snippets (tracked)
  .gitignore                     mine (replaces the base configuration's allow-list)
```

The two base files are replaced by hand when the base configuration changes:
copy the new `early-init.el` and `init.el` over the old ones, read the diff, and
commit only those two files. There is no remote for it: the repository has one
history, its own.

The `.gitignore` change was required, not optional: the base configuration's own
file ignores everything and allow-lists only its four files. Without replacing
it, `post-init.el` and `modules/` would have been invisible to git.

## 5. Public / private split rule

- Public: any package selection, any keybinding, any default, any mode setup.
- Private: absolute paths outside `~/.emacs.d`, identities, machine paths, employer
  hosts/projects/tooling, anything with a secret.
- Private modules load last, so a private file can override any public default without
  editing the public file.

## 5.1 Decisions taken (2026-10-14)

| Topic | Decision |
|---|---|
| Build location | `~/Projects/emacs.d-new`, then switch. Old config keeps working until then. |
| Package manager | `package.el` + `package-vc`. No straight.el, no elpaca. |
| Completion | `corfu` + `cape`. Drop `company`, `company-box`, `company-quickhelp`, the icon table, `company-web`. |
| LSP | built-in `eglot`. Drop `lsp-mode`, `lsp-ui`, `lsp-treemacs`, `lsp-docker`, `dap-mode`. |
| Projects | keep `projectile` and `treemacs-projectile`. |
| Language stacks | Ruby, Python, JS/TS (built-in `js-ts-mode`/`tsx-ts-mode`), web-mode, Org + Markdown, sh/yaml/json/dockerfile/terraform/graphql. No Go. |
| AI | none for now. No `aidermacs`, no `claude-code-ide`, no `eca`, no `gptel`. Add later. |
| hydra | rewrite the flycheck and per-mode menus with built-in `transient`. |
| Icons | `nerd-icons` instead of `all-the-icons`. |
| Drop | `nyan-mode`, `dimmer`, `magit-delta`, `git-gutter-fringe` (keep `blamer` + Magit), `popwin` (use `display-buffer-alist`). |
| Org | drop `org-agenda-files`, all `org-capture-templates`, `org-wild-notifier`. Keep Org editing and `org-modern`. |

Resolved on 2026-10-14, in the same round of questions:
- `undo-tree` → `undo-fu` + `undo-fu-session`. The `s-/` visualizer is accepted as lost.
- `smartparens` → built-in `electric-pair-mode` only. The old config never used any `sp-` API.
- `highlight-indent-guides` → `indent-bars` (GNU ELPA, bitmap based).
- `vterm` → dropped. Nothing else in the config uses it, and `vterm-module.so` was never built.
- Tree-sitter: install grammars for ruby, python, javascript, typescript, tsx, yaml, css, bash, json, then use the `-ts` modes.

Still open (none blocks the scaffold):
- `blamer` uses the internal function `browse-at-remote--commit-url`. Keep or switch to `magit-blame`/`git-messenger`.
- `untabify-mode`: keep the on-save untabify, or rely on `indent-tabs-mode nil` alone.
- `terraform-mode` / `docker`: the binaries are absent. Keep the modes for editing, or drop the modules.

## 6. Numbers to expect after the rewrite

- Packages: 145 installed → about 70–85 configured, and all of them deferred.
- Startup: 14s → target under 1s (the base configuration reports 0.22s with 146 packages,
  on the author's machine).
- `git add .` risk today: 114 MB (`eca/`) plus 88 MB (`packages/`) is ignored, but
  `eca/` is not.

## 7. What the new config's own checks found (2026-10-14)

The new tree has three checks that the old config never had: `make check-syntax`
(read every file), `make check-load` (load everything, fail on any warning) and
`make validate` (every `:custom` name must exist). They found real breakage in
config that had been written by hand and looked fine.

**Settled by `make validate` — options that no longer exist.** Each of these was
a `setq`/`:custom` of a name no package defines: Emacs creates the variable,
nothing reads it, and the setting silently does nothing.

| Name written in the old config | Reality in October 2026 |
|--------------------------------|-------------------------|
| `wgrep-change-on-exit`         | the option is `wgrep-change-readonly-file` |
| `magit-clone-set-remote-HEAD`  | capital HEAD: the real name is `magit-clone-set-remote-head` |
| `undo-fu-session-compatible-modes`, `undo-fu-session-global-exclude-modes` | neither exists; the option is `undo-fu-session-incompatible-major-modes` |
| `which-key-min-display-columns` | gone; which-key is built into Emacs 31 (3.6.1) and has no such option |
| `marginalia-annotator-registry` | renamed `marginalia-annotators`, and the built-in table needs no editing |
| `corfu-preview-action`, `corfu-echo-documentation` | removed from corfu; the equivalents are `corfu-preview-current`, `corfu-echo-delay` and `corfu-popupinfo-delay` |
| `eshell-continuation` | never existed; dropped |
| `mac-emulate-three-button-mouse` | belonged to the old Carbon Mac port; the Nextstep build has no equivalent |

**Settled by `make check-load` — forms that failed at runtime.** `use-package`
catches the error from each form and turns it into a warning, so Emacs started
normally and only a message nobody read was left behind.

- `transient-define-prefix` in `rl-check.el` (the flycheck menu on `C-c f`) used
  the pre-0.13 suffix order. transient 0.13 wants `("key" "description"
  command)`; with the command first it refuses to expand. The menu had never
  worked.
- `use-package transient` also had the definition in `:preface`, which runs
  before the package is loaded, so the command was void even after expansion.
  It is now in `:config` with `:demand t`, because the prefix has to exist when
  the key is bound.
- `("C-q C-u" . rl-string-inflection-cycle)`: `C-q` is `quoted-insert`, not a
  prefix, so the binding was rejected. Now `C-c M-u`.
- `scss-mode` (last released 2018) pushes onto `flymake-allowed-file-name-masks`,
  which Emacs 31's flymake no longer defines, so loading it died halfway
  through. The variable is declared in `:preface` so the old push is harmless;
  checking comes from flycheck.
- A `use-package emacs` block in `rl-keys.el` was missing one closing paren, so
  everything after `C-l` in that form — `M-u`, `M-l`, `C-c r`, `C-c a` — was
  never bound. `check-syntax` only catches this if the temp buffer is in
  `emacs-lisp-mode`: in `fundamental-mode` a `;` is not a comment, and a plain
  read loop stops at the last complete form and calls the rest end-of-file,
  which looks like success.

**Settled by reading Emacs 31.**

- `treesit-auto` (Emacs 30) is gone. Emacs 31 picks TS modes through
  `treesit-enabled-modes`, which fills `major-mode-remap-alist` — and only
  through its `:set`, so `customize-set-variable` and not `setq`.
- `--batch` now implies `-q`. Batch runs load no init file at all, which is why
  `package-deps.el` and `validate-config.el` set up `package.el` themselves and
  why the timing targets use a pseudo terminal.
- `treesit-language-source-alist` ships empty, so every grammar recipe has to be
  written down (it is, in `modules/rl-treesit.el`).
