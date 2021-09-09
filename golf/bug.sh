# https://codegolf.stackexchange.com/questions/129523/it-was-just-a-bug
seq -- -8 8|xargs -I: sh -c 'seq -s"`printf "%:s_"`" 10'|sed s/_1*//g
