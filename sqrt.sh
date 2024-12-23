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

calculate_sqrt() {
  local number=$1
  local epsilon=0.000001
  local guess=$number

  while [ $(echo "$guess * $guess - $number" | bc) -gt $epsilon ]; do
    guess=$(echo "($guess + $number / $guess) / 2" | bc -l)
  done

  echo $guess
}

main(){
  debug -f main "$@"
  calculate_sqrt "$@"
}

adlib debug install

main "$@"

