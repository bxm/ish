#!/bin/sh

if ! type adlib 1>/dev/null 2>&1 ; then
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
fi

boxes(){
  debug -f main "$@"
  input="$(cat input)"
}

adlib debug install tty

main "$@"

