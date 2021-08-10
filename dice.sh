#!/bin/sh

elaborate() {
  debug "Elaborating size${1}"
  set -- $(size${1})
  # strip line defs to get pattern
  PATTERN=$(echo "$@" | grep -Eo ",[0-9,]+,")
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

_char_small(){
cat << EOF
.....
....o
..o..
o....
o...o
EOF
}

_char_medium(){
cat << EOF
:....:
::..()
:.().:
()..::
()::()
EOF
}

_char_large(){
cat << EOF
:.........:
::......(@)
:...(@)...:
(@)......::
(@):...:(@)
EOF
}

size1(){
  _char_small  
  _pattern_1_line
}

size2(){
  _char_medium | _h_squash
  _pattern_1_line
}

size3(){
  _char_medium
  _pattern_1_line
}

size4(){
  size3 | _h_pad_in | _v_pad_in
}

size5(){
  _char_large | _h_pad_out
  _pattern_1_line | _v_pad_in | _v_pad_out
}

size6(){
  size5 | _v_pad_in | _h_pad_in
}

size7(){
  size6 | _v_pad_out | _h_pad_out | _h_pad_out
}

size8(){
  size7 | _v_pad_in | _h_pad_in #| _h_pad_out
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
  NOT=0
  ROLL=0
  while [ $# -gt 0 ] ; do
    case "${1}" in
      (clear ) CLEAR=true ;;
      (![1-6]) NOT=${1/!} ;;
      ([1-6] ) FORCE=${1} ;;
    esac
    shift
  done
  ${DEBUG} && CLEAR=false
  debug "NOT: ${NOT}"
  debug "FORCE: ${FORCE}"
  set -- ${DIE}
  if [ "${FORCE}" -gt 0 ] ; then
    ROLL="${FORCE}"
  else
    while true ; do
      ROLL=$((RANDOM % 6 + 1))
      [ "${NOT}" -eq 0 ] && break
      [ "${NOT}" -ne "${ROLL}" ] && break
    done
  fi
  debug "ROLL: ${ROLL}"

  eval FACE="\$${ROLL}" # assign the face value per the random number
  draw_face
  return ${ROLL}
}

prompt(){
  unset REPLY
  printf "Roll again? "
  while true ; do
    IFS= read -n1 -s REPLY
    debug "REPLY: ${REPLY}"
    case "${REPLY}" in
      ([qQnN]) echo ; return 1 ;;
      ([1-9] ) set_die "${REPLY}" ; return 0 ;;
      ('['   ) : ;;
      ([\ -~]) echo ; return 0 ;;
    esac
  done
}

set_die(){
  DIE="$(elaborate ${1})"
}

main_loop(){
  LAST=0
  while true ; do
    for A in 1 2 3 4 5 6 ; do
      if ${TEST} ; then
        roll ${A}
      else
        roll clear !${LAST}
        LAST=$?
        echo Rolling...
      fi
      sleep 0.15
    done

    ${TEST} || roll clear
    prompt || break
  done
}

debug(){
  ${DEBUG} && echo "DEBUG: $*" >&2
}

process_params(){
  SIZE=1
  TEST=false
  DEBUG=false

  while [ $# -gt 0 ] ; do
    case "${1}" in
      ([1-9]|[1-9][0-9]) SIZE=${1} ;;
      (-t|--test ) TEST=true ;;
      (-d|--debug) DEBUG=true ;;
    esac
    shift
  done

  set_die "${SIZE}"
}

main(){
  process_params "${@}"
  main_loop
}
main "${@}"
