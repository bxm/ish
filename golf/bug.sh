# https://codegolf.stackexchange.com/questions/129523/it-was-just-a-bug
for p in `seq 9 -1 2;seq 9`;do seq -s"`printf "%${p}s\b"`" 9 ;done|sed s/$/0/
