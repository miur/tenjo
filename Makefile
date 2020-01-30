#
# SPDX-FileCopyrightText: 2020 Dmytro Kolomoiets <amerlyq+tenjo@gmail.com>
#
# SPDX-License-Identifier: Apache-2.0
#
.DEFAULT_GOAL = reuse

pkgname := tenjo
bdir := _build

.PRECIOUS: %/
%/: ; +@mkdir -p '$@'


.PHONY: reuse
reuse:
	reuse lint


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
