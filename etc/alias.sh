# vim: ft=sh
#
# SPDX-FileCopyrightText: 2020 Dmytro Kolomoiets <amerlyq+tenjo@gmail.com>
#
# SPDX-License-Identifier: Apache-2.0
#
#%SUMMARY: define optional aliases (if not present) and cleanup after yourself
#%BUG: loaded only on "login" and never inherited by newly opened X terminals
#   https://bbs.archlinux.org/viewtopic.php?id=248224 ⌇⡞⡁⡃⡂
#%

function _tenjo_alias { local nm=$1; shift
  command -v -- "$nm" >/dev/null 2>&1 && return
  # shellcheck disable=SC2139
  builtin alias -- "$nm=$*"
}

function _tenjo_init {
  # BET:(zsh-only): $ { ... } always { unfunction -m "_tenjo_*"; }
  #   Re: Local inner functions ⌇⡞⡂⣣⡹
  #     https://www.zsh.org/mla/users/2011/msg00207.html
  function TRAPEXIT { unset -f _tenjo_alias _tenjo_init; }  # if $ZSH_NAME
  [[ -n ${BASH-} ]] && trap 'TRAPEXIT; unset -f TRAPEXIT; trap - RETURN' RETURN

  ## [_] FIND: how to define local name for function ⌇⡞⡁⠮⢮
  # declare -rn A=_tenjo_alias
  _tenjo_alias t  tenjo
  _tenjo_alias ta tenjo add
  _tenjo_alias tx tenjo expand
}

_tenjo_init
