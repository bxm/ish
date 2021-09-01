unset REPLY
while read -s -n1 -t0.2 REPLY || true ; do
  [ "$REPLY" = q ] && break
  time wget http://example.com/ -T3 -o /dev/null -O /dev/null 2>&1 | grep real
done | awk '{gsub(/s/,"",$NF); print $NF}' 
