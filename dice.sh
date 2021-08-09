# deprecated
rand(){
  strings /dev/urandom | grep -Eo "[1-6]" | head -1
}

elaborate() {
  set -- $(size${1})
  # strip line defs to get pattern
  PATTERN=$(echo "$@" | grep -Eo "[0-9,]+")
  for P in ${PATTERN} ; do
    for I in ${P//,/ } ; do
      eval printf "%s/" \$${I}
    done
    echo
  done
}

_layout(){
cat <<EOF
,1,,3,,1,
,2,,1,,4,
,2,,3,,4,
,5,,1,,5,
,5,,3,,5,
,5,,5,,5,
EOF
}

_inner_blanks(){
  sed 's/,,/,,1,/g'
}

_outer_blanks(){
  sed 's/^,/,1,/;s/,$/,1,/'
}

_h_pad_outer(){
  sed -r 's/[^0-9, ]+/.&./'
}

_h_pad_inner(){
  sed -r 's/[:]/:../g'
}

size1(){
cat << EOF
.....
....o
..o..
o....
o...o
EOF
_layout
}

size2(){
cat << EOF
....
..()
.().
()..
()()
EOF
_layout
}

size3(){
cat << EOF
:....:
::..()
:.().:
()..::
()::()
EOF
_layout
}

size4(){
  size3 | _h_pad_inner | _inner_blanks
}

size5(){
cat << EOF | _h_pad_outer
:.........:
::......(@)
:...(@)...:
(@)......::
(@):...:(@)
EOF
_layout | _inner_blanks | _outer_blanks
}

size6(){
  size5 | _inner_blanks | _h_pad_inner
}

size7(){
  size6 | _outer_blanks | _h_pad_outer | _h_pad_outer
}

draw_face(){
  FACE="${FACE//\// }"
  H_LINE=".${FACE// *}."
  H_LINE=" ${H_LINE//?/-} "
  ${CLEAR} && clear
  echo
  echo "${H_LINE}"
  for LINE in ${FACE} ; do
    printf "| "
    printf "${LINE//[.:]/ }"
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
  draw_face
}

prompt(){
  unset REPLY
  printf "Roll again? "
  read -n1 -s REPLY
  case "${REPLY}" in
    ([qQnN]) echo ; false ;;
    ([1-9] ) set_die "${REPLY}" ;;
    (*     ) true ;;
  esac
}

set_die(){
  DIE="$(elaborate ${1})"
}

main(){
  SIZE=1
  DEBUG=false
  while [ $# -gt 0 ] ; do
    case "${1}" in
      ([1-9]|[1-9][0-9]) SIZE=${1} ;;
      (-d|--debug) DEBUG=true ;;
    esac
    shift
  done

  set_die "${SIZE}"
  while true ; do
    for A in 1 2 3 4 5 6 ; do
      if ${DEBUG} ; then
        roll ${A}
      else
        roll clear
        echo Rolling...
      fi
      sleep 0.15
    done

    ${DEBUG} || roll clear
    prompt || break
  done
}
main "${@}"
