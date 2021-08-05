unset REPLY ; while read -n1 -t0.2 REPLY || true ; do [ "$REPLY" = q ] && break ; time wget htt
p://example.com/ -O f 2>&1 | grep real ; done | awk '{
print $NF}'
