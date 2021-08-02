SMOOTH=${1:-3}
ITER=${2:-5}

while [ ${ITER} -gt 0 ] ; do
ping 8.8.8.8 -c ${SMOOTH} \
  | grep -oE time=[^\ ]+ \
  | awk -F= '{n+=$NF ; i+=1} END {print n/i}'
: $((ITER-=1))
done
