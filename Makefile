# My Emacs configuration.  See README.md.
#
# early-init.el, init.el and .LICENSE are the base configuration: third-party
# files, never edited by hand.  Everything of mine is in pre-*.el, post-*.el,
# modules/, check-syntax.el, check-load.el, package-deps.el and
# validate-config.el.
#
# Emacs 31 note: `--batch' implies `-q'.  A batch run therefore loads neither
# early-init.el nor init.el.  Targets that need the real config either pass
# --init-directory without --batch, or load the two files explicitly.

EMACS    ?= emacs

# Read every .el file.  Catches unbalanced parentheses and invalid characters
# without loading anything.
check-syntax:
	$(EMACS) -Q --batch -l check-syntax.el

# Load the whole configuration and fail if any warning was raised.  use-package
# turns a broken form into a warning, so a target that only checks the exit
# status would still pass.
check-load:
	$(EMACS) --init-directory "$(CURDIR)" -Q --batch -l check-load.el \
		--load "$(CURDIR)/early-init.el" --load "$(CURDIR)/init.el" \
		--eval '(rl-check-load-report)' --kill

# Load the declared packages and check that every option named in `:custom'
# and `:custom-face' really exists.  This catches settings that do nothing,
# which is the most common way an Emacs config rots.
validate:
	$(EMACS) -Q --batch -l validate-config.el

# Byte-compile the modules.  The config is loaded first so the compiler can
# see the packages: without that, every option set by `:custom' and every
# autoloaded command produces a "free variable" or "might not be defined at
# runtime" warning, and a real mistake hides among them.
compile:
	$(EMACS) --init-directory "$(CURDIR)" -Q --batch \
		--load "$(CURDIR)/early-init.el" --load "$(CURDIR)/init.el" \
		-L modules -f batch-byte-compile modules/*.el

clean-elc:
	rm -f modules/*.elc modules-private/*.elc

# The packages the modules declare.  package-deps.el configures package.el
# itself because --batch implies -q in Emacs 31.
list-deps:
	$(EMACS) -Q --batch -l package-deps.el

install-deps:
	$(EMACS) -Q --batch -l package-deps.el -- --install

# Start Emacs with this configuration, without touching ~/.emacs.d.
run:
	$(EMACS) --init-directory "$(CURDIR)"

# Same, with errors reported instead of caught by use-package.
run-debug:
	$(EMACS) --init-directory "$(CURDIR)" --debug-init

# Time the real startup: pseudo terminal, full init, exit at once.
startup:
	@for i in 1 2 3; do \
		script -q /dev/null sh -c 'TIMEFORMAT=%R; time $(EMACS) --init-directory "$(CURDIR)" --eval "(kill-emacs)" >/dev/null 2>&1' 2>/dev/null | tail -1 ; \
	done

# Time the same Elisp in batch, loading the two files by hand (no GUI frame).
startup-load:
	@for i in 1 2 3; do \
		/usr/bin/time $(EMACS) -Q --batch --load "$(CURDIR)/early-init.el" --load "$(CURDIR)/init.el" --kill 2>&1 | tail -1 ; \
	done

# Compile the tree-sitter grammars that are missing.  Needs git and a C
# compiler; writes into var/tree-sitter.
grammars:
	$(EMACS) --init-directory "$(CURDIR)" -Q --batch \
		--load "$(CURDIR)/early-init.el" --load "$(CURDIR)/init.el" \
		--eval '(rl-treesit-install-missing)' --kill

# Report missing tree-sitter grammars and missing external programs.  The list
# of programs lives in modules/rl-doctor.el, not here.
doctor:
	$(EMACS) --init-directory "$(CURDIR)" -Q --batch \
		--load "$(CURDIR)/early-init.el" --load "$(CURDIR)/init.el" \
		--eval '(mapc (lambda (line) (princ (concat line "\n"))) (rl-doctor-report))' \
		--kill

.PHONY: check-syntax check-load validate compile clean-elc list-deps install-deps run run-debug startup startup-load grammars doctor
