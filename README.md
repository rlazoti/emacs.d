My Emacs Conf
=============

My Emacs conf based on Emacs Prelude.

## Requirements

* It requires Emacs 24 or higher.

##Intalation

To install, clone this repo to `~/.emacs.d`, i.e. ensure that the
`init.el` contained in this repo ends up at `~/.emacs.d/init.el`:

```bash
git clone https://github.com/rlazoti/emacs.d.git .emacs.d
```

#### Update all bundled packages

Just run <kbd>M-x package-list-packages RET U x</kbd>.


### Keymap

#### Global

Keybinding            | Description
----------------------|------------------------------------------------------------
<kbd>C-l</kbd>        | Go to line number (`goto-line`).
<kbd>C-+</kbd>        | Increase font size (`text-scale-increase`).
<kbd>C--</kbd>        | Decrease font size (`text-scale-decrease`).
<kbd>C-c left</kbd>   | Switch the focus to visible buffer at the left side.
<kbd>C-c up</kbd>     | Switch the focus to visible buffer at the up side.
<kbd>C-c right</kbd>  | Switch the focus to visible buffer at the right side.
<kbd>C-c down</kbd>   | Switch the focus to visible buffer at the down side.
<kdb>Meta-A</kdb>     | Start a vertical editing block.
<kbd>C-x f</kbd>      | Find files in the current directory (fiplr).
<kbd>C-x C-f</kbd>    | Find files in the current directory (helm).
<kbd>C-c C-f</kbd>    | Find for a value in all files of a directory (helm).
<kbd>F6</kbd>         | Open/Close a file explorer (sr-bspeedbar).


-Rodrigo Lazoti
