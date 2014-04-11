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

## Keymap

### Global

Keybinding            | Description
----------------------|------------------------------------------------------------
<kbd>C-l</kbd>        | Go to line number (`goto-line`).
<kbd>C-+</kbd>        | Increase font size (`text-scale-increase`).
<kbd>C--</kbd>        | Decrease font size (`text-scale-decrease`).
<kbd>C-c left</kbd>   | Switch the focus to visible buffer at the left side.
<kbd>C-c up</kbd>     | Switch the focus to visible buffer at the up side.
<kbd>C-c right</kbd>  | Switch the focus to visible buffer at the right side.
<kbd>C-c down</kbd>   | Switch the focus to visible buffer at the down side.
<kdb>M-S-a</kdb>      | Start a vertical editing block.
<kbd>C-x f</kbd>      | Find files in the current directory (fiplr).
<kbd>F5</kbd>         | Refresh the file explorer (sr-bspeedbar).
<kbd>F6</kbd>         | Open/Close the file explorer (sr-bspeedbar).
<kbd>C-c r</kbd>      | Run the current file(buffer) (ex: file.rb is going to run ruby interpreter).
<kbd>M-up</kbd>       | Move the current line or region up.
<kbd>M-down</kbd>     | Move the current line or region down.
<kbd>C-i</kbd>        | Indent a line or a region.
<kbd>C-c n</kbd>      | Create a new buffer.

### iTerm2 meta arrow keybindings

profile key bindings under iTerm2 and add bindings for the following:

```
M-up      : Esc-[1;4A
M-down    : Esc-[1;4B
M-right   : Esc-[1;4C
M-left    : Esc-[1;4D]]]]
```

## Author

-Rodrigo Lazoti
