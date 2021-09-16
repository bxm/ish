#!/bin/sh

adlib(){
  local realname="$(readlink -f "${0}")"
  local libdir="${realname%/*}/lib"
	while [ $# -gt 0 ] ; do
		local libname="${1%.sh}.sh"
		source "${libdir}/${libname}" || continue
    debug added "${libdir}/${libname}"
		shift
	done
}

main(){
  debug main "$@"
  cd ${HOME}/code/ish
  local f="$(
    find . -type f -name "DOT_${1:?}*" | head -1
  )"
  [ "${f}" ] || return
  home_f="${HOME}/.${f#./DOT_}"
  debug -v f home_f
  nvim "${home_f}"
}

adlib debug

main "$@"

