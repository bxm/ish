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

convoluted(){
  debug -f native "$@"
  m=-rwxr-x--x
  echo ${m:1}
  seq 1 9 | while read i ; do
    : $((q=((9-i)%3),x=q<<1))
    x=${x/0/1}
    j=${m:$i:1}
    k=${j/[^-]/$x}
    k=${k/-/0}
    [ $((q>>1)) = 1 ] && f=$k || : $((f+=k))
    #printf "$x $q $j $k"
    #[ $q = 0 ] && echo " $f" || echo
    [ $q = 0 ] && printf "$f"
  done
  echo
}

splitpipes() {
  m=-rwxr-x--x
  j=0
  echo ${m:1}
  echo ${m:1} | tr "rwx-" "4210" | sed -r 's/.{3}/&:/g;s/./&\n/g' | while read i ; do if [ "$i" = : ] ; then printf $j ; j=0 ; else : $((j+=i)) ; fi ; done
  echo
}

adlib debug install

convoluted "$@"
splitpipes

