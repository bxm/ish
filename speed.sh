ping 8.8.8.8 -c ${1:-5} \
  | grep -oE time=[^\ ]+ \
  | awk -F= '{n+=$NF ; i+=1} END {print n/i}'
