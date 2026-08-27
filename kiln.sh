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
  cd "${realname%/*}" || exit
  for h in $(seq 48) ; do
    for q in 0 25 50 75 ; do
      t=$(awk -v T0=$s -v half=11 -v hours=$h.$q -f _kiln.awk)
      if [ ${t//.*} -lt 95 ] ; then
        echo $h.$q hours $t C
        abs_date "${h}"
        return
      fi
    done
  done
}

adlib debug install

install

main "$@"

