# https://codegolf.stackexchange.com/questions/129523/it-was-just-a-bug
for p in `seq -- -8 8`;do seq -s"`printf "%${p}s_"`" 10;done|sed s/_1*//g
