# https://codegolf.stackexchange.com/questions/129523/it-was-just-a-bug
for p in `seq 9 -1 2;seq 9`;do seq -s"`printf "%${p}s_"`" 10;done|sed s/10/0/\;s/._//g
