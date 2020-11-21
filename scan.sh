#!/usr/bin/env sh
multi_thread(){                                         
  seq -s $'\n'192.168.0. 0 254 \
    | tail +2 \
    | xargs -n1 -P64 -I% \
       $0 do $* % \
    | sort -V
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
  case "$1" in
    (do       ) shift ; $* ;;
    (port|ping) multi_thread $* ;;
    (*        ) usage ;;
  esac
}

main "$@"
