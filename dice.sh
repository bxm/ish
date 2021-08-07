rand(){
  strings /dev/urandom | grep -Eo "[1-6]" | head -1
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
size2(){
cat << EOF
......../......../...().../......../........
()....../......../......../......../......()
()....../......../...().../......../......()
()....()/......../......../......../()....()
()....()/......../...().../......../()....()
()....()/......../()....()/......../()....()
EOF
}

draw_face(){
  echo
  echo "${H_LINE}"
  for line in ${FACE} ; do
    printf "| "
    printf "${line//./ }"
    printf " |"
    echo
  done
  echo "${H_LINE}"
  echo
}

roll(){
  [ "${1}" = c ] && CLEAR=true || CLEAR=false
  # RAND="$(rand)"
  set -- ${DIE}
  RAND=$((RANDOM % 6 + 1))
  eval FACE="\$${RAND}" # assign the face value per the random number
  FACE="${FACE//\// }"
  H_LINE=".${FACE// *}."
  H_LINE=" ${H_LINE//?/-} "
  ${CLEAR} && clear
  draw_face
}

basic(){
  v=$((RANDOM % 6 + 1))
  set -- one two three four five six
  eval echo ${v} \$${v}
}

prompt(){
  unset REPLY
  printf "Roll again? "
  read -n1 -s REPLY
  case "${REPLY}" in
    ([qQnN]) echo ; false ;;
    (*     ) true  ;;
  esac
}

main(){
  case "${1}" in
    ([1-2]) SIZE=size${1} ;;
    (*    ) SIZE=size1    ;;
  esac
  DIE="$(${SIZE})"
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
main "${@}"
