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
  case "$*" in
    (*-* ) false ;;
    (rows|lines) get_tty && printf '%s' "$LINES" ;;
    (cols      ) get_tty && printf '%s' "$COLUMNS" ;;
  esac
}

adlib debug install tty

install

main "$@"

