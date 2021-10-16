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
   -f nspeed.awk
#     '/time=/ {
#       i++
# time=$7
# gsub(/[^[:digit:].]/,"",time)
# time=int(time)
# total+=time
# avg=total/i
# #print time,max
# if (time>max) {
# max=time*1.0
# mflag="+"}else{mflag=""}
# timepc=time/max
# barcols=(timepc*(cols-5))
# #print timepc
# printf "%4s%1s",time,mflag
# #for(c=0;c<barcols;c++) {printf "#"}
# for(c=0;c<cols-5;c++) {
# if(c<barcols){printf "#"}else{printf " "}
# }
# printf "\n"}'
# count whole width, drop marker on avg (need cols value). Drop marker on current and spaces for rest?
}

adlib debug install

main "$@"

