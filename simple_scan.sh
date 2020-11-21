

seq 1 255 \
 | xargs -n1 -P32 -i% \
   nc 192.168.0.% 22 -vz -w1 2>&1 \
 | grep open

