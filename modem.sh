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
    # q is inverted modulus of i
    : $((q=(9-i)%3))
    # double q to get x, which
    # corresponds to 2/3 of the mode octal values
    : $((x=q*2))
    # fix remaining octal value to 1
    x=${x/0/1}
    # j gets char number i of mode
    j=${m:$i:1}
    # k is j with non hyphen replaced with x
    k=${j/[^-]/$x}
    # fix those hyphens
    k=${k/-/0}
    # when r-bitshifted q is 1 its first of a triple
    # so f is set to k, otherwise incremented by k
    [ $((q>>1)) = 1 ] && f=$k || : $((f+=k))
    #printf "$x $q $j $k"
    #[ $q = 0 ] && echo " $f" || echo
    # when q is 0 at end of triple so print total f
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

