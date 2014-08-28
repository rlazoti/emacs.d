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
<kbd>M-c</kbd>        | Capitalize a word (position your cursor before the word).
<kbd>M-C</kbd>        | Capitalize a region (position your cursor after region).
<kbd>M-l</kbd>        | Make a word lowercase (position your cursor before the word).
<kbd>M-L</kbd>        | Make a region lowercase (position your cursor after region).
<kbd>M-u</kbd>        | Make a word uppercase (position your cursor before the word).
<kbd>M-U</kbd>        | Make a region uppercase (position your cursor after region).
<kbd>M-;</kbd>        | Comment/uncomment selected lines or the current line.
<kbd>C-+</kbd>        | Increase font size (`text-scale-increase`).
<kbd>C--</kbd>        | Decrease font size (`text-scale-decrease`).
<kbd>C-c left</kbd>   | Switch the focus to visible buffer at the left side.
<kbd>C-c up</kbd>     | Switch the focus to visible buffer at the up side.
<kbd>C-c right</kbd>  | Switch the focus to visible buffer at the right side.
<kbd>C-c down</kbd>   | Switch the focus to visible buffer at the down side.
<kbd>C-c n</kbd>      | Create a new buffer.
<kbd>C-c r</kbd>      | Replace all occurrences of a string in the current buffer.
<kbd>C-i</kbd>        | Indent a line or a region.
<kbd>C-l</kbd>        | Go to line number (`goto-line`).
<kbd>C-s</kbd>        | Current buffer incremental find.
<kbd>C-c C-s</kbd>    | Current buffer incremental find defined by marked (selected) text.
<kbd>C-S-s</kbd>      | Find for a term in all files of current directory.
<kbd>C-x f</kbd>      | Find files in the current directory (fiplr).
<kbd>M-up</kbd>       | Move the current line or region up.
<kbd>M-down</kbd>     | Move the current line or region down.
<kbd>F5</kbd>         | Refresh the file explorer (sr-bspeedbar).
<kbd>F6</kbd>         | Open/Close the file explorer (sr-bspeedbar).
<kbd>F8</kbd>         | Run the current file(buffer) (ex: file.rb is going to run ruby interpreter).
<kbd>F9</kbd>         | Open an interactive shell into current buffer (`shell`).

### iTerm2 meta arrow keybindings

profile key bindings under iTerm2 and add bindings for the following:

```
M-up      : Esc-[1;4A
M-down    : Esc-[1;4B
M-right   : Esc-[1;4C
M-left    : Esc-[1;4D]]]]
```

### Reload the config without exiting Emacs

If you change any file you can reload all the configuration without exiting emacs just typing:

<kbd>M-x reload-config RET</kbd>

## Author

-Rodrigo Lazoti
