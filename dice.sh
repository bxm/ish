rand(){
  strings /dev/random | grep -Eo "[1-6]" | head -1
}

size1(){
  echo \
    ...../..o../..... \
    o..../...../....o \
    o..../..o../....o \
    o...o/...../o...o \
    o...o/..o../o...o \
    o...o/o...o/o...o
}

roll(){
  #i=$((RANDOM % 6 + 1))
  i=$(rand)
  set -- $DIE
  eval r="\$$i"
  r="${r//\// }"
  hline=".${r// *}."
  hline=" ${hline//?/-} "
  clear
  echo
  echo "$hline"
  printf "| %s |\n| %s |\n| %s |" $r | sed 's/[.]/ /g'
  echo
  echo "$hline"
  echo
}

basic(){
  v=$((RANDOM % 6 + 1))
  set -- one two three four five six
  eval echo $v \$$v
}

main(){
  DIE="$(size1)"
  while true ; do
    for x in a a a a a ; do
      roll
      echo Rolling...
      sleep 0.15
    done
    roll
    unset ROLL
    read -n1 -s ROLL
    [ "${ROLL/Q/q}" = q ] && break  
  done
}
main 
