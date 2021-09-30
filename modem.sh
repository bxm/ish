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
  m=-rwxr-x--x
  seq 1 9 | while read i ; do
    : $((q=((9-i)%3),x=q<<1))
    x=${x/0/1}
    j=${m:$i:1}
    k=${j/[^-]/$x}
    k=${k/-/0}
    [ $((q>>1)) = 1 ] && f=$k || : $((f+=k))
    printf "$x $q $j $k"
    [ $q = 0 ] && echo " $f" || echo
  done


}

adlib debug install

main "$@"

