# deprecated
rand(){
  strings /dev/urandom | grep -Eo "[1-6]" | head -1
}

elaborate() {
  set -- $(size${1})
  # strip line defs to get pattern
  PATTERN=$(echo "$@" | grep -Eo ",[0-9,]+")
  for P in ${PATTERN} ; do
    for I in ${P//,/ } ; do
      eval printf "%s/" \$${I}
    done
    echo
  done
}

_v_pad_in(){
  sed 's/,,/,,1,/g'
}

_v_pad_out(){
  sed 's/^,/,1,/;s/,$/,1,/'
}

_h_pad_out(){
  sed -r 's/[^0-9, ]+/.&./'
}

_h_pad_in(){
  sed 's/[:]/:../g'
}

_h_squash(){
  sed 's/[:]//g'
}

_pattern_1_line(){
cat <<EOF
,1,,3,,1,
,2,,1,,4,
,2,,3,,4,
,5,,1,,5,
,5,,3,,5,
,5,,5,,5,
EOF
}

# TODO: these should be charset1, 2, 3 with sizes modifying those

size1(){
cat << EOF
.....
....o
..o..
o....
o...o
EOF
  _pattern_1_line
}

size3(){
cat << EOF
:....:
::..()
:.().:
()..::
()::()
EOF
  _pattern_1_line
}

size2(){ # like 3 only smaller
  size3 | _h_squash
}

size4(){
  size3 | _h_pad_in | _v_pad_in
}

size5(){
cat << EOF | _h_pad_out
:.........:
::......(@)
:...(@)...:
(@)......::
(@):...:(@)
EOF
  _pattern_1_line | _v_pad_in | _v_pad_out
}

size6(){
  size5 | _v_pad_in | _h_pad_in
}

size7(){
  size6 | _v_pad_out | _h_pad_out | _h_pad_out
}

size8() {
  size5 | _h_squash
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
  # TODO: remove -n1
  #       add brief timeout
  #       loop until not blank
  #       - timeout gives 1 exit code
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
