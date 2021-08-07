rand(){
  strings /dev/random | grep -Eo "[1-6]" | head -1
}

size1(){
cat << EOF
...../..o../.....
o..../...../....o
o..../..o../....o
o...o/...../o...o
o...o/..o../o...o
o...o/o...o/o...o
EOF
}

roll(){
  #i=$((RANDOM % 6 + 1))
  [ "$1" = c ] && CLEAR=true
  i=$(rand)
  set -- $DIE
  eval r="\$$i"
  r="${r//\// }"
  hline=".${r// *}."
  hline=" ${hline//?/-} "
  $CLEAR && clear
  echo
  echo "$hline"
#  printf "| %s |\n| %s |\n| %s |" $r | sed 's/[.]/ /g'
  for line in $r ; do
    printf "| "
    printf "${line//./ }"
    printf " |"
    echo
  done
  echo "$hline"
  echo
}

basic(){
  v=$((RANDOM % 6 + 1))
  set -- one two three four five six
  eval echo $v \$$v
}

prompt(){
  unset ROLL
  printf "Roll again? "
  read -n1 -s ROLL
  echo $ROLL
  [ "${ROLL/Q/q}" != q ]
}

main(){
  DIE="$(size1)"
  while true ; do
    for x in a a a a a ; do
      roll c
      echo Rolling...
      sleep 0.15
    done

    roll c
    prompt || break
  done
}
main 
