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

block(){
  case $1 in
    (half)
      printf "\u2584" ;;
    (full)
      printf "\u2588" ;;
  esac
}

col(){
  local length=$1
  local full=$((length / 2))
  local half=$((length % 2))
  local col
  #local seq="{0..$full}"
  #printf %s. $seq
  echo $length
  #for i in ((i=1;i++;i>length)) ; do
  test $half -eq 1 && col+=($(block half))
  for i in $(seq 1 $full) ; do
    col+=($(block full))
  done
  printf %s"\n" ${col[*]}
  #printf '%s' $(block full) $(block half)
}

main(){
  debug -f main "$@"
  local list=/tmp/list
  make_list
  #cat ${list}
  col 1
  col 2
  col 3
  col 15
  
}

adlib debug install
install

main "$@"

