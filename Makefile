#
# SPDX-FileCopyrightText: 2020 Dmytro Kolomoiets <amerlyq+tenjo@gmail.com>
#
# SPDX-License-Identifier: Apache-2.0
#
.POSIX:
.DEFAULT_GOAL = reuse

this := $(lastword $(MAKEFILE_LIST))
here := $(patsubst %/,%,$(dir $(realpath $(this))))

pkgname := tenjo
bdir := _build

prefix := /usr/local
bindir := $(DESTDIR)$(prefix)/bin
libexecdir := $(DESTDIR)$(prefix)/libexec
datadir := $(DESTDIR)$(prefix)/share
sysconfdir := $(DESTDIR)$(if $(prefix:/usr=),$(prefix))/etc
d_prf := $(sysconfdir)/profile.d
dexe := $(libexecdir)/$(call ifname,$(pkgname))


.PRECIOUS: %/
%/: ; +@mkdir -p '$@'


.PHONY: reuse
reuse:
	reuse lint


.PHONY: dev-install
dev-install:
	install -d '$(bindir)' '$(d_prf)'
	ln -svfT '$(here)/$(pkgname)' '$(bindir)/$(pkgname)'
	ln -svfT '$(here)/etc/alias.sh' '$(d_prf)/$(pkgname).sh'


# ln -svfT '$(d_pj)' '$(dexe)'
# ln -svfT '$(dexe)/kirie/kirie' '$(bindir)/$(pkgname)'
# install -d '$(datadir)/zsh/site-functions'
# ln -svfT '$(here)/zsh-completion' '$(datadir)/zsh/site-functions/_$(pkgname)'


.PHONY: pkg-install
pkg-install: force := 1
pkg-install: install := 1
pkg-install: pkg-build


.PHONY: pkg-build
pkg-build: PKGBUILD
	install -vCDm644 -t '$(bdir)/_pkg' '$<'
	ln -srvfT '$(shell pwd)' $(bdir)/_pkg/src
	env -C '$(bdir)/_pkg' -- makepkg --syncdeps --clean \
	  $(if $(force),--force) $(if $(install),--install) \
	  $(_args) >/dev/tty
