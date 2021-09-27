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
  local realname="$(readlink -f "${0}")"
  local realdir="${realname%/*}"
  find . -mindepth 1 -maxdepth 1 -name 'DOT_*' \
    | awk -v home="$HOME" \
    '{targ = $0;link = $0;sub(/^DOT_/,home"/.",link);print targ,link}' # FIXME just use sed!

}

adlib debug

main "$@"

