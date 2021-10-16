#!/bin/sh

adlib(){
  local realname="$(readlink -f "${0}")"
  local libdir="${realname%/*}/lib"
  while [ $# -gt 0 ]
do
    local libname="${1%.sh}.sh"
    source "${libdir}/${libname}" || continue
    debug added "${libdir}/${libname}"
    shift
  done
}

main(){
  debug -f main "$@"
ping 8.8.8.8 | awk \
  -vcols=$(tput cols) -vtimepc=0 -vbarcols=0 \
  -vtotal=0 -vi=0 -vmax=0 \
    '/time=/ {
      i++
time=$7
gsub(/[^[:digit:]]/,"",time)
total+=time
avg=total/i
if (time>max) {max=time*1.1
print "max increased"}
timepc=time/max
barcols=timepc*cols
for(c=0;c<barcols;c++) {printf "#"}
printf "\n"}'
}

adlib debug install

main "$@"

