# deprecated
rand(){
  strings /dev/urandom | grep -Eo "[1-6]" | head -1
}

elaborate() {
  set -- $(${1})
  PATTERN=$(shift 5;echo "$@")
  for P in ${PATTERN} ; do
    for I in ${P//,/ } ; do
      eval printf "%s/" \$${I}
    done
    echo
  done
}

_noblanks(){
cat <<EOF
1,3,1
2,1,4
2,3,4
5,1,5
5,3,5
5,5,5
EOF
}

_inblanks1(){
sed 's/,/,1,/g'
}

size1(){
cat << EOF
.....
....o
..o..
o....
o...o
EOF
_noblanks
}

size2(){
cat << EOF
......
....()
..()..
()....
()..()
EOF
_noblanks
}

size3(){
cat << EOF
........
......()
...()...
()......
()....()
EOF
_noblanks | _inblanks1
}

size4(){
cat << EOF
.........../.........../.........../....(@)..../.........../.........../...........
.........../(@)......../.........../.........../.........../........(@)/...........
.........../(@)......../.........../....(@)..../.........../........(@)/...........
.........../(@).....(@)/.........../.........../.........../(@).....(@)/...........
.........../(@).....(@)/.........../....(@)..../.........../(@).....(@)/...........
.........../(@).....(@)/.........../(@).....(@)/.........../(@).....(@)/...........
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
  CLEAR=false
  FORCE=0
  while [ $# -gt 0 ] ; do
    case "${1}" in
      (clear) CLEAR=true ;;
      ([1-6]) FORCE=${1} ;;
    esac
    shift
  done

  set -- ${DIE}
  if [ "${FORCE}" -gt 0 ] ; then
    ROLL="${FORCE}"
  else
    ROLL=$((RANDOM % 6 + 1))
  fi
  eval FACE="\$${ROLL}" # assign the face value per the random number
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
    ([1-9] ) DIE="$(elaborate size${REPLY})" ; true ;;
    (*     ) true ;;
  esac
}

main(){
  # TODO proper param handling
  SIZE=1
  while [ $# -gt 0 ] ; do
    case "${1}" in
      ([1-9]) SIZE=${1} ;;
    esac
    shift
  done

  #DIE="$(size${SIZE})"
  DIE="$(elaborate size${SIZE})"
  while true ; do
    for ANIMATE in 1 2 3 4 5 6 ; do
      roll clear
      echo Rolling...
      sleep 0.15
    done

    roll clear
    prompt || break
  done
}
main "${@}"
