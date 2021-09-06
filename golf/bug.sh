# https://codegolf.stackexchange.com/questions/129523/it-was-just-a-bug
for p in $(seq 8 -1 1;seq 2 8);do for x in $(seq 1 10);do printf "%${p}d" $((x%10));done|sed 's/^ *//';echo;done
