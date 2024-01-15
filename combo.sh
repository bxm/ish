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
  cat .combo.dat \
    | grep -Eo "[0-9]{2}" \
    | awk '{print $1;print substr($1,2,1) "" substr($1,1,1)}' \
    | sort -u | shuf | head -2 \
    | tr -d '\n'
  echo
  }

adlib debug install

install

main "$@"

