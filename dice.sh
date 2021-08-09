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

_inblanks(){
  sed 's/,,/,,1,/g'
}

_outblanks(){
  sed 's/^,/,1,/;s/,$/,1,/'
}

_pad(){
  sed -r 's/[^0-9, ]+/.&./'
}

_expand(){
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
......
....()
..()..
()....
()..()
EOF
_layout
}

size4(){
cat << EOF
........
......()
...()...
()......
()....()
EOF
_layout | _inblanks
}

size5(){
cat << EOF | _pad
:.........:
::......(@)
:...(@)...:
(@)......::
(@):...:(@)
EOF
_layout | _inblanks | _outblanks
}

size6(){
  size5 | _inblanks | _expand
}

size7(){
  size6 | _outblanks | _pad | _pad
}

draw_face(){
  echo
  echo "${H_LINE}"
  for line in ${FACE} ; do
    printf "| "
    printf "${line//[.:]/ }"
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
