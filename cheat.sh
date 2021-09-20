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
  set -e
  debug main "$@"
  local realname="$(readlink -f "${0}")"
  local mydir="${realname%/*}"
  local cheat_dir="${mydir}/cheat"
  local cheat="${cheat_dir}/${1}.txt"
  if [ -f "${cheat}" ] ; then
    cat "${cheat}" | pgr
  else
    cd "${cheat_dir}"
    ls | sed 's/[.]txt$//g'
  fi
}

adlib debug

main "$@"

