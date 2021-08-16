#!/bin/sh

is_array(){
  local a="${1:?Need array name}"
  local e # helper var listing array elements
  local s # array size
  eval e="\"\${${a}_E}\""
  eval s="\"\${${a}_S}\""
  [ -n "${e}" ] && [ -n "${s}" ]
  # could also validate all elements exist
}

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
  is_array $a || return
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

array_dump(){
  debug "array_dump $@"
  local a="${1:?Need array name}" # array name
  is_array $a || return
  # populate local vars
  local e # helper var listing array elements
  local s_var="${a}_S"
  local e_var="${a}_E"
  eval e="\"\${$e_var}\""
  debug s_var: $s_var
  debug e_var: $e_var
  debug a: $a
  debug e: $e
  for element in $e ; do
    debug eval echo "\"\$${element}\""
  done
  for element in $e ; do
    eval echo "\"\$${element}\""
  done

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
    : $((s++))
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
  set -- $(size${1} 2>/dev/null || size1)
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

make_face(){
  
  local LINE
  local FACE="$(array_get DIE ${1:?})"
  local FACE_NO="${2:?}"
  local FA=FACE_$FACE_NO # face array pointer
  debug FA: $FA
  debug FACE: "${FACE}"
  FACE="${FACE//\// }"
  debug FACE: "${FACE}"
  local H_LINE=".${FACE// *}."
  H_LINE=" ${H_LINE//?/-} "
  array_new ${FA} "$H_LINE"
  for LINE in ${FACE} ; do
    debug LINE: "$LINE"
    array_push $FA "| ${LINE//[.:]/ } |"
  done
  array_push ${FA} "$H_LINE"
}

build_face_list(){
  local i=0
  while [ $i -lt $DICE ] ; do
    debug i: $i
    : $((i++))
    if [ "${FORCE}" -gt 0 ] ; then
      ROLL="${FORCE}"
    else
      while true ; do
        ROLL=$((RANDOM % DIE_S + 1))
	      [ $DICE -ne 1 ] && break
        [ "${NOT}" -eq 0 ] && break
        [ "${NOT}" -ne "${ROLL}" ] && break
        debug re-roll
      done
    fi
    
    debug "ROLL: ${ROLL}"

    #draw_face "${ROLL}"
    make_face "${ROLL}" $i
    face_list="${face_list:+${face_list} } FACE_$i"
  done
  debug face_list: $face_list
}

show_face_list(){
  do_clear
  echo
  indexes="$(seq 1 $FACE_1_S)"
  for l in $indexes ; do
    for f in $face_list ; do
      eval echo -n "\"\$${f}_${l}\""
    done
    echo
  done
  echo
}

roll(){
  local FORCE=0
  local NOT=0
  local ROLL=0
  local face_list=''
  while [ $# -gt 0 ] ; do
    case "${1}" in
      (![1-6]) NOT=${1/!} ;;
      ([1-6] ) FORCE=${1} ;;
    esac
    shift
  done
  debug "NOT: ${NOT}"
  debug "FORCE: ${FORCE}"

  build_face_list 
  show_face_list

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
  for A in $(seq 1 6) ; do
    if ${TEST} ; then
      roll ${A}
      continue
    fi
    ${QUICK} && break
    roll !${LAST}
    LAST=$?
    printf "Rolling..."
    sleep 0.15
  done
}

main_loop(){
  while true ; do
    animate_loop
    ${TEST} || roll
    prompt || break
  done
}

debug(){
  ${DEBUG} && printf "## DEBUG ## >>$*<<\n" >&2
}

do_clear(){
  ${TEST} && return
  ${DEBUG} && return
  clear
}

process_params(){

  debug process_params "$@"
  while [ $# -gt 0 ] ; do
    case "${1}" in
      ( [0-9]| [1-9][0-9]) SIZE=${1} ;;
      (x[0-9]|x[1-9][0-9]) DICE=${1/x} ;;
      (-t|--test ) TEST=true ;;
      (-d|--debug) DEBUG=true ;;
      (-q|--quick) QUICK=true ;;
    esac
    shift
  done
  debug DICE: "${DICE}" SIZE: "${SIZE}"
  debug TEST: "${TEST}" QUICK: "${QUICK}"
}

main(){
  SIZE=1
  DICE=1
  TEST=false
  DEBUG=false
  QUICK=false

  debug main "$@"
  process_params "${@}"
  set_die "${SIZE}"
  main_loop
}
main "${@}"
