# vim:ft=sh
#
# SPDX-FileCopyrightText: 2020 Dmytro Kolomoiets <amerlyq+tenjo@gmail.com>
#
# SPDX-License-Identifier: Apache-2.0
#
# Maintainer: Dmytro Kolomoiets <amerlyq+tenjo@gmail.com>
#
# shellcheck shell=bash disable=SC2034,SC2154
pkgname=tenjo
pkgver=0.0.1
pkgrel=1
pkgdesc='Tasks enframing journal -- to manage, track and account your goals and progress'
url='https://github.com/amerlyq/tenjo/'
license=('Apache-2.0')
arch=('any')

depends=(
  # docker
  git  # OR: mercurial
  zsh
)

makedepends=(
  reuse
)

package() {
  prefix=$pkgdir/usr
  datadir=$prefix/share

  make dev-install prefix=/usr DESTDIR="$pkgdir"
  # make install prefix="$prefix"

  install -Dm644 -t "$datadir/licenses/$pkgbase" -- $(printf 'LICENSES/%s.txt\n' "${license[@]}")
  install -Dm644 -t "$datadir/doc/$pkgbase" -- README.rst
}
