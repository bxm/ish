#!/usr/bin/env sh
SMOOTH=${1:-3}
ITER=${2:-5}

while [ ${ITER} -gt 0 ] ; do
  : $((ITER-=1))

  while [ ${SMOOTH} -gt 0 ] ; do
    : $((SMOOTH-=1))
    echo "  ${ITER} / ${SMOOTH}\r\c" >&2
    ping 8.8.8.8 -c 1
    sleep 0.1
  done \
    | grep -oE time=[^\ ]+ \
    | awk -F= '{n+=$NF ; i+=1} END {print "\n"n/i}'

done
