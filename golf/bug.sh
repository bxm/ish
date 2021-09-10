# https://codegolf.stackexchange.com/questions/129523/it-was-just-a-bug
# 2399c533b9c5fd67050a9d2ae3aab0f8  output hash
seq -- -8 8|xargs -I: sh -c 'seq -s"`printf "%:s_"`" 10'|sed s/_1*//g
