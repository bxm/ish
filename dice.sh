#!/bin/sh

array_get(){
  debug "array_get $@"
  # $1 expects to be array name but also tolerates
  # being the full element label if $2 omitted
  local ar="${1:?}"
  local el="${2}"
  eval echo -n "\"\${${ar}${el:+_${el}}}\""
}

array_new(){
  debug "array_new $@"
  array_delete "${1}"
  array_push "${@}"
}

array_delete(){
  debug "array_delete $@"
  local a="${1:?Need array name}" # array name
  # populate local vars
  local e # helper var listing array elements
  local s_var="${a}_S"
  local e_var="${a}_E"
  eval e="\"\${$e_var}\""
  debug s_var: $s_var
  debug e_var: $e_var
  debug a: $a
  debug e: $e
  debug unset ${e} ${s_var} ${e_var}
  unset ${e} ${s_var} ${e_var}

}

array_push(){
  debug "array_push $@"
  local a="${1:?Need array name}" # array name
  # TODO: be opinionated about 'a' content (validate)
  local s='' # array size
  local e='' # helper var listing array elements
  # populate local vars
  local s_var="${a}_S"
  local e_var="${a}_E"
  eval s="\"\${$s_var:-0}\""
  eval e="\"\${$e_var}\""
  debug s_var: $s_var
  debug e_var: $e_var
  shift # ditch array name, keep the rest
  debug a: $a s: $s
  # while will short circuit and ignore empty pushes
  while [ $# -gt 0 ] ; do 
    : $((s+=1))
    debug eval ${a}_${s}="\"${1}\""
    eval ${a}_${s}="\"${1}\""
    e="${e:+${e} }${a}_${s}"
    shift
  done
  debug a: $a s: $s
  debug e: $e
  # push local vars back to array
  eval $s_var="\"$s\""
  eval $e_var="\"$e\""
}

elaborate() {
  debug "Elaborating size${1}"
  set -- $(size${1})
  # strip line defs to get pattern
  PATTERN=$(echo "$@" | grep -Eo ",[0-9,]+,")
  debug "PATTERN:\n${PATTERN}"
  for P in ${PATTERN} ; do
    for I in ${P//,/ } ; do
      eval printf "%s/" \$${I}
    done
    echo
  done
}

x_sed() {
  debug x_sed "$@"
  local i="${2:-1}"
  local SED_CMD=''
  while [ "${i}" -gt 0 ] ; do
    : $((i-=1))
    SED_CMD="${SED_CMD};$1"
  done
  sed -r "${SED_CMD}"
}

_pad(){
  debug _pad "$@"
  local DIR="${1:?}"
  local LOC="${2:?}"
  local TIM="${3:-1}"
  _${DIR}_pad_${LOC} ${TIM}
} 

_v_pad_in(){
  # use embedded ,, as marker to insert blank lines
  x_sed 's/,,/,,1,/g' ${1}
}

_v_pad_out(){
  # use leading and trailing , as marker to insert blank lines
  x_sed 's/^,/,1,/;s/,$/,1,/' ${1}
}

_h_pad_out(){
  # anything that doesn't have the form of a pattern gets extra .
  x_sed 's/[^0-9, ]+/.&./' ${1}
}

_h_pad_in(){
  # use : as a marker to insert extra .
  x_sed 's/[:]/:../g' ${1}
}

_h_squash(){
  # remove any : markers
  sed 's/[:]//g'
}

_patt_1_line(){
# extraneous leading, trailing and embedded , are markers for _v_pad_in/out
cat <<EOF
,1,,3,,1,
,2,,1,,4,
,2,,3,,4,
,5,,1,,5,
,5,,3,,5,
,5,,5,,5,
EOF
}

_patt_double_1_line(){
# extraneous leading, trailing and embedded , are markers for _v_pad_in/out
cat <<EOF
,1,1,,3,3,,1,1,
,2,2,,1,1,,4,4,
,2,2,,3,3,,4,4,
,5,5,,1,1,,5,5,
,5,5,,3,3,,5,5,
,5,5,,5,5,,5,5,
EOF
}

_char_small(){
cat << EOF
:...:
::..o
:.o.:
o..::
o:.:o
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

_char_xlarge(){
cat << EOF
:...........:
::......(@@@)
:...(@@@)...:
(@@@)......::
(@@@):.:(@@@)
EOF
}

size0(){
  _char_small | _h_squash
  _patt_1_line
}

size1(){
  _char_small
  _patt_1_line
}

size2(){
  _char_medium | _h_squash
  _patt_1_line
}

size3(){
  _char_medium
  _patt_1_line
}

size4(){
  size3 | _pad h in | _pad v in
}

size5(){
  _char_large | _pad h out
  _patt_1_line | _pad v in | _pad v out
}

size6(){
  size5 | _pad v in | _pad h in
}

size7(){
  size6 | _pad v out | _pad h out 2
}
size8(){
  _char_xlarge | _pad h in 2 | _pad h out
  _patt_double_1_line | _pad v in 2 | _pad v out
}

draw_face(){
  local FACE="$(array_get DIE ${1})"
  #eval FACE="\"\${DIE_${1}}\""
  eval FACE="\"\${DIE_${1}}\""
  debug FACE: "${FACE}"
  FACE="${FACE//\// }"
  debug FACE: "${FACE}"
  local H_LINE=".${FACE// *}."
  local LINE
  H_LINE=" ${H_LINE//?/-} "
  ${CLEAR} && clear
  echo
  echo "${H_LINE}"
  for LINE in ${FACE} ; do
    LINE="| ${LINE//[.:]/ } |"
    echo "${LINE}"
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

  draw_face "${ROLL}"
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
      ([0-9] ) set_die "${REPLY}" ; return 0 ;;
      ('['   ) : ;;
      ([\ -~]) return 0 ;;
    esac
  done
}

set_die(){
  local DIE="$(elaborate ${1})"
  debug "DIE:\n${DIE}"
  array_new DIE ${DIE}
  debug DIE_S: "${DIE_S}"
  debug DIE_E: "${DIE_E}"
}

animate_loop(){
  LAST=0
  for A in 1 2 3 4 5 6 ; do
    if ${TEST} ; then
      roll ${A}
      continue
    fi
    ${QUICK} && break
    roll clear !${LAST}
    LAST=$?
    printf "Rolling..."
    sleep 0.15
  done
}

main_loop(){
  while true ; do
    animate_loop
    ${TEST} || roll clear
    prompt || break
  done
}

debug(){
  ${DEBUG} && printf "## DEBUG ## >>$*<<\n" >&2
}

process_params(){

  debug process_params "$@"
  while [ $# -gt 0 ] ; do
    case "${1}" in
      ([0-9]|[1-9][0-9]) SIZE=${1} ;;
      (-t|--test ) TEST=true ;;
      (-d|--debug) DEBUG=true ;;
      (-q|--quick) QUICK=true ;;
    esac
    shift
  done

}

main(){
  SIZE=1
  TEST=false
  DEBUG=false
  QUICK=false

  process_params "${@}"
  debug main "$@"
  set_die "${SIZE}"
  main_loop
}
main "${@}"
