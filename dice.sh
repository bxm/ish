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
....../..()../......
()..../....../....()
()..../..()../....()
()..()/....../()..()
()..()/..()../()..()
()..()/()..()/()..()
EOF
}

size3(){
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
  case "${1}" in
    (clear) CLEAR=true ;;
    (*    ) CLEAR=false ;;
  esac
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
  # TODO proper param handling
  case "${1}" in
    ([1-9]) SIZE=size${1} ;;
    (*    ) SIZE=size1    ;;
  esac
  DIE="$(${SIZE})"
  while true ; do
    for ANIMATE in 1 2 3 4 5 ; do
      roll clear
      echo Rolling...
      sleep 0.15
    done

    roll clear
    prompt || break
  done
}
main "${@}"
