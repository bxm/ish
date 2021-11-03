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
  while [ ${i} -gt 0 ] ; do
    : $((i--))
    REPLY=''
    read -n1 -s -t1
    case "${REPLY}" in
      ([qQrRmMaA]) break ;;
      (*     ) REPLY='' ;;
    esac
  done
  # TODO look at system date, work out if we have slept long enough
}

ping() {
  local wait=3
  local REPLY=''
  local uname=$(uname -s -r)
  case "${uname}" in
    (Linux*-ish|Linux*-linuxkit) : ;;
    (Darwin*)    wait="${wait}000" ;;
    (*)          wait='' ;;
  esac
  : "${wait:?"${uname} is not handled"}"
  while true ; do
    printf "%s %s %s " $(tput cols) $(date +%F_%T) "${REPLY:-none}"
    REPLY=''
    # TODO start timer here
    #      read time at end of loop and sleep for remainder of loop
    command ping -c1 -W${wait} "$@" 2>/dev/null \
      | grep -Eo "time=[[:digit:].]+"
    [ $? -ne 0 ] && echo -1
    # isleep should read the timer we started
    # and return once enough time has elapsed
    isleep 3
    [ "${REPLY}" = q ] && return
  done
}

before_exit(){
  printf "${CUR_ON}\n"
}

trap "exit" 2
trap "before_exit" 0

main(){
  debug -f main "$@"
  local realname="$(readlink -f "${0}")"
  local ip
  printf "${CUR_OFF}"
  case "${1}" in
    (r*) ip=192.168.1.1 ;;
    (* ) ip=8.8.8.8 ;;
  esac
  ping ${ip} \
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

