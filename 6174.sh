#!/usr/bin/env bash

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

join(){
  printf "%s" $*
}

main(){
  debug -f main "$@"
  for x in 1 2 3 4 ; do
    n="${n} $((RANDOM % 10))"
  done
  small=$(printf "%s\n" $n | sort)
  large=$(printf "%s\n" $n | sort -r)

  join $small
  echo
  join $large
  echo
  
}

adlib debug install

main "$@"

