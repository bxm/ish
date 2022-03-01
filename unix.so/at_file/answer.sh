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
  debug -f main "$@"
}

adlib debug install

main "$@"
# https://unix.stackexchange.com/questions/679237/can-i-indirect-the-argument-list-to-a-bash-script-from-a-text-file
