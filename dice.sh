rand(){
  strings /dev/random|grep -Eo "[1-6]" | head -1
}

roll(){
  #i=$((RANDOM % 6 + 1))
  i=$(rand)
  set -- \
    ...../..o../..... \
    o..../...../....o \
    o..../..o../....o \
    o...o/...../o...o \
    o...o/..o../o...o \
    o...o/o...o/o...o

  eval r="\$$i"
  r="${r//\// }"
  top=".${r// *}."
  top=" ${top//?/-} "
  clear
  echo
  echo "$top"
  printf "| %s |\n| %s |\n| %s |" $r | sed 's/[.]/ /g'
  echo
  echo "$top"
  echo
}

basic(){
  v=$((RANDOM % 6 + 1))
  set -- one two three four five six
  eval echo $v \$$v
}

main(){
  while true ; do
    for x in a a a a a ; do
      roll
      echo Rolling...
      sleep 0.1
    done
    roll
    unset ROLL
    read -n1 -s ROLL
    [ "${ROLL/Q/q}" = q ] && break  
  done
}
main 
