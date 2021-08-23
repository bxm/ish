#!/bin/sh
loop() {
    s="$(seq 1 30000)"
  for x in $s ; do
    "$@"
  done
}

main(){
  if [ "$1" = --spawn ] ; then
    shift
    loop "$@"
  else
    [ $# -le 0 ] && return 1
    time "$0" --spawn "$@"
  fi
}

main "$@"
