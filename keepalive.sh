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

is_running(){
  pgrep -f "$PROC" | grep -q .
}

status(){
  is_running && echo up || { echo down ; false ; } >&2
}


kill_it(){
  status 1>/dev/null || return 0
  pkill -f "$PROC"
}

run_it(){
  status 2>/dev/null && return 0
  cat /dev/location >/dev/null &
}

main(){
  debug main "$@"
  PROC="cat /dev/location"
  case "$1" in
    (k*) kill_it ;;
    (r*) run_it ;;
    (* ) status ;;
  esac
}

adlib debug

main "$@"

