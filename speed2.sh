unset REPLY
while read -n1 -t0.2 REPLY || true ; do
  [ "$REPLY" = q ] && break
  time wget http://example.com/ -T3 -o /dev/null -O f 2>&1 \
    | grep real
done | awk '{print gsub(/twarts/,"",$NF)}' 
