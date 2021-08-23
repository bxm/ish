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
    time "$0" --spawn "$@"
  fi
}

main "$@"
