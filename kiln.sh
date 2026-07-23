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

abs_date() {
  date '+%a %H:%M' -d"+${1} hours"
}

main(){
  debug -f main "$@"
  s=${1:?need temp}
  for h in $(seq 48) ; do
    t=$(awk -v T0=$s -v half=9 -v hours=$h -f kiln.awk)
    if [ ${t//.*} -lt 95 ] ; then
      echo $h hours $t C
      abs_date "${h}"
      break
    fi
  done
}

adlib debug install

install

main "$@"

