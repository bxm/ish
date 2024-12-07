#!/bin/bash

# this is going kinda wrong
# so we have our numbers
# we need to fill an array with blocks
# we need another array filled with
# the respective lengths. do that first
# from the list.
# we need a third array which has the index
# numbers of the first two arrays
# then we process this--
# no, just the two arrays. we go through
# the lengths array, deciding if we need to
# swap, if we swap we peeform same op on the
# block array

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
  local chr
  case $1 in
    (half)
      printf -vchr "\u2584" ;;
    (full)
      printf -vchr "\u2588" ;;
  esac
  char[$1]=$chr
}

col(){
  local length=$1
  local full=$((length / 2))
  local half=$((length % 2))
  local -a col
  #local seq="{0..$full}"
  #printf %s. $seq
  echo $length
  #for i in ((i=1;i++;i>length)) ; do
  test $half -eq 1 && col+=(${char[half]})
  for i in $(seq 1 $full) ; do
    col+=(${char[full]})
  done
  #printf %s"\n" ${col[*]}


  #printf '%s' $(block full) $(block half)
}

main(){
  debug -f main "$@"
  local list=/tmp/list
  local -A char
  make_list
  block half
  block full
  # printf '%s\n' ${char[*]}
  #cat ${list}
  local -a col_c
  local -a col_l
  while read -r item ; do
    col $item
  done < $list
  
}

adlib debug install
install

main "$@"

