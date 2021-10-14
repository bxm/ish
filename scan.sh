#!/bin/sh

multi_thread(){
  seq -s $'\n'192.168.1. 0 254 \
    | tail +2 \
    | xargs -n1 -P64 -I% \
       $0 do $* % \
    | sort -V
  true
# flip params around so ip comes first
# then we could have multiple ports
# that breaks the case, would need to split first param
# like port/ping and put the rest after %
}

port(){
  nc $2 $1 -z -w1 >/dev/null 2>&1 \
    || return
  echo $2:$1 open - $(getname $2)
}

getname(){
  nslookup $1 | awk -F" " '$2 == "name" {print $NF}'
}

ping(){
  command ping $1 -W1 -c1 >/dev/null 2>&1 \
    && echo $1 up - $(getname $1)
}

usage() {
  exec >&2
<<EOF cat
Usage: ${0##*/} [ping|port #]
Perform a simple ping/port scan of the local network
EOF
  exit
}

parse_range() {
  # split off final octet
  #   if hyphen present is range otherwise single
  # generate three arrays, subnet, start octet, end octet
  true
}

main() {
  if [ "$1" = do ] ; then shift ; "$@" ; return ; fi

  while [ $# -gt 0 ] ; do
    case "$1" in
# do it like port:22 thus range is implied, allowing multiples
      (port) ACTION="$1" ; PARAM="$2" ; shift ;;
      (ping) ACTION="$1" ;;
# allow multiple ranges via assoc array
# -- ash does not support arrays at all
      (-r?*|--range=?*) RANGE="${1#-r}" ; RANGE="${RANGE#*=}" ;;
      (-r  |--range   ) RANGE="${2}" ; shift ;;
      (*) usage ;;
    esac
    shift
  done
  # parse range func
  # error if no action
  # sane defaults for range and port?
  multi_thread $ACTION $PARAM
}

main "$@"
