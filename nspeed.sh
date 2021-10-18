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

isleep(){
  local i="${1:-1}"
  while [ $i -gt 0 ] ; do
    : $((i--))
    REPLY=''
    read -n1 -s -t1
    [ -n "$REPLY" ] && break
  done
}

ping() {
  local wait=2
  local cmd=''
  local uname=$(uname -s -r)
  case "${uname}" in
    (Linux*-ish) : ;;
    (Darwin*)    wait="${wait}000" ;;
    (*)          wait='' ;;
  esac
  : "${wait:?"${uname} is not handled"}"
  while true ; do
    printf "%s %-2s" $(date +%F_%T) ${cmd:-x}
    cmd=''
    command ping -c1 -W${wait} "$@" 2>/dev/null \
      | grep -Eo "time=[[:digit:].]+"
    if [ $? -eq 0 ] ; then
      read -n1 -s -t3 cmd
      continue
    fi
    echo dead
    sleep 1
  done
}

main(){
  debug -f main "$@"
  local realname="$(readlink -f "${0}")"
  ping 8.8.8.8 \
    | awk \
    -vcols=$(tput cols) -vtimepc=0 -vbarcols=0 \
    -vtotal=0 -vi=0 -vmax=0 \
    -vred="${RED}" \
    -vyel="${YELLOW}" \
    -vgrn="${GREEN}" \
    -vion="${INV_ON}" \
    -vioff="${INV_OFF}" \
    -vnc="${_NC_}" \
    -vmaxout=500 \
    -f "${realname%.sh}.awk"
  }

adlib debug install decor

install

main "$@"

