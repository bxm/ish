# https://unix.stackexchange.com/q/670492/40482
grep -Eo ",[[:digit:]]+" input.txt | tr -d ","

grep -Eo ",[[:digit:]]+" input.txt | grep -Eo "[^,]+"
