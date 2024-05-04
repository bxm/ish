#!/bin/bash

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

make_list(){
  test -e ${list} && return
  shuf -i1-22 > ${list}
}

main(){
  debug -f main "$@"
  local list=/tmp/list
  make_list
  cat ${list}

  
}

block(){
  case $1 in
    (half)
      printf "\u2584" ;;
    (full)
      printf "\u2588" ;;
  esac
}

adlib debug install
install

main "$@"

