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
  pgrep -f "$PROC" >/dev/null
}

status(){
  if is_running ; then
    echo up
  else
    echo down >&2
    false
  fi
}

kill_it(){
  status 1>/dev/null || return 0
  pkill -f "$PROC"
  status
}

run_it(){
  status 2>/dev/null && return 0
  printf "Starting..."
  cat /dev/location >/dev/null &
  status
}

main(){
  debug main "$@"
  PROC="cat /dev/location"
  case "$1" in
    (d*|k*) kill_it ;;
    (u*|r*) run_it ;;
    (* ) status ;;
  esac
}

adlib debug

main "$@"

