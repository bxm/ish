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
  local i="${1:?}"
  while [ $i -gt 0 ] ; do
    : $((i--))
    REPLY=''
    read -n1 -s -t1
    REPLY="${REPLY// }"
    [ -n "${REPLY}" ] && break
  done
  # TODO look at system date, work out if we have slept long enough
}

ping() {
  local wait=2
  local REPLY=''
  local uname=$(uname -s -r)
  case "${uname}" in
    (Linux*-ish) : ;;
    (Darwin*)    wait="${wait}000" ;;
    (*)          wait='' ;;
  esac
  : "${wait:?"${uname} is not handled"}"
  while true ; do
    printf "%s %s %-2s" $(tput cols) $(date +%F_%T) ${REPLY:-x}
    REPLY=''
    command ping -c1 -W${wait} "$@" 2>/dev/null \
      | grep -Eo "time=[[:digit:].]+"
    if [ $? -eq 0 ] ; then
      isleep 3
      continue
    fi
    echo dead
    isleep 1
  done
}

main(){
  debug -f main "$@"
  local realname="$(readlink -f "${0}")"
  # TODO: run tput every loop and pass cols value to awk
  ping 8.8.8.8 \
    | awk \
    -vred="${RED}" \
    -vyel="${YELLOW}" \
    -vgrn="${GREEN}" \
    -vion="${INV_ON}" \
    -vioff="${INV_OFF}" \
    -vnc="${_NC_}" \
    -vmaxout_val=500 \
    -f "${realname%.sh}.awk"
  }

adlib debug install decor

install

main "$@"

