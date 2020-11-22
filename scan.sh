#!/usr/bin/env sh

multi_thread(){                                         
  seq -s $'\n'192.168.0. 0 254 \
    | tail +2 \
    | xargs -n1 -P64 -I% \
       $0 do $* % \
    | sort -V
  true
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

main() {
  if [ "$1" = do ] ; then shift ; "$@" ; return ; fi

  while [ $# -gt 0 ] ; do
    case "$1" in
      (port) ACTION="$1" ; PARAM="$2" ; shift ;;
      (ping) ACTION="$1" ;;
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
