# https://codegolf.stackexchange.com/questions/129523/it-was-just-a-bug
for p in $(seq 9 -1 1;seq 2 9);do seq -s"$(printf "%${p}s\b" "")" 1 10 ;done|sed 's/10/0/'
