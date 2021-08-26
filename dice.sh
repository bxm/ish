#!/bin/sh

is_array(){
  # check if passed array exists
  # TODO could also validate all elements exist
  debug "is_array $@"
  local a="${1:?Need array name}"
  local e # helper var listing array elements
  local s # array size
  eval e="\"\${${a}_E}\""
  eval s="\"\${${a}_S}\""
  if [ -n "${e}" ] && [ -n "${s}" ] ; then
    debug ${a} looks arrayish
    return 0
  fi
  debug ${a} is not an array
  false
}

array_get(){
  # store array element in given variable
  debug "array_get $@"
  local element="${1:?}"
  local var="${2:?}"
  eval ${var}="\"\$${element}\""
}

array_new(){
  debug "array_new $@"
  array_delete "${1}"
  array_push "${@}"
}

array_delete(){
  debug "array_delete $@"
  local a="${1:?Need array name}" # array name
  is_array ${a} || return
  # populate local vars
  local e # helper var listing array elements
  local s_var="${a}_S"
  local e_var="${a}_E"
  eval e="\"\${${e_var}}\""
  debug s_var: ${s_var}
  debug e_var: ${e_var}
  debug a: ${a}
  debug e: ${e}
  debug unset ${e} ${s_var} ${e_var}
  unset ${e} ${s_var} ${e_var}
}

array_dump(){
  debug "array_dump $@"
  local a="${1:?Need array name}" # array name
  is_array ${a} || return
  # populate local vars
  local e # helper var listing array elements
  local s_var="${a}_S"
  local e_var="${a}_E"
  eval e="\"\${${e_var}}\""
  debug s_var: ${s_var}
  debug e_var: ${e_var}
  debug a: ${a}
  debug e: ${e}
  for element in ${e} ; do
    debug eval echo "\"\$${element}\""
  done
  for element in ${e} ; do
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
  eval s="\"\${${s_var}:-0}\""
  eval e="\"\${${e_var}}\""
  debug s_var: ${s_var}
  debug e_var: ${e_var}
  shift # ditch array name, keep the rest
  debug a: ${a} s: ${s}
  # while will short circuit and ignore empty pushes
  while [ $# -gt 0 ] ; do
    : $((s++))
    debug eval ${a}_${s}="\"${1}\""
    eval ${a}_${s}="\"${1}\""
    e="${e:+${e} }${a}_${s}"
    shift
  done
  debug a: ${a} s: ${s}
  debug e: ${e}
  # push local vars back to array
  eval ${s_var}="\"${s}\""
  eval ${e_var}="\"${e}\""
}

elaborate() {
  debug "Elaborating size${1}"
  set -- $(size${1} 2>/dev/null || size1)
  # strip line defs to get pattern
  PATTERN=$(echo "$@" | grep -Eo ",[0-9,]+,")
  debug "PATTERN:\n${PATTERN}"
  local h_line=".-${1//?/-}-."
  for P in ${PATTERN} ; do
    printf "%s/" "$h_line"
    for I in ${P//,/ } ; do
      eval printf "\|.%s.\|/" "\$${I}"
    done
    printf "%s/" "$h_line"
    echo
  done
}

x_sed() { # perform sed action multiple times
  debug x_sed "$@"
  local i="${2:-1}"
  local sed_cmd=''
  while [ "${i}" -gt 0 ] ; do
    : $((i-=1))
    sed_cmd="${sed_cmd};$1"
  done
  sed -r "${sed_cmd}"
}

_pad(){
  debug _pad "$@"
  local dir="${1:?}"
  local loc="${2:?}"
  local tim="${3:-1}"
  _${dir}_pad_${loc} ${tim}
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

_patt_mvp(){
  seq 1 6 | sed 's/.*/,&,/'
}

# extraneous leading, trailing and embedded , are markers for _v_pad_in/out
_patt_1_line(){
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
cat <<EOF
,1,1,,3,3,,1,1,
,2,2,,1,1,,4,4,
,2,2,,3,3,,4,4,
,5,5,,1,1,,5,5,
,5,5,,3,3,,5,5,
,5,5,,5,5,,5,5,
EOF
}

_patt_seg(){
cat << EOF
,4,4,4,4,4,
,1,4,1,3,1,
,1,4,1,4,1,
,2,2,1,4,4,
,1,3,1,4,1,
,1,3,1,2,1,
EOF
}

_char_mvp(){
  seq 1 6
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

_char_segment(){
cat << EOF
.###.
#:.:#
#..::
::..#
:...:
EOF
}

sizeseg(){
  _char_segment
  _patt_seg
}

sizemvp(){
  _char_mvp
  _patt_mvp
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

how_many(){
  get_tty
  debug how_many "$@"

  debug COLUMNS $COLUMNS

  PER_LINE=$((COLUMNS / $1))
  debug PER_LINE $PER_LINe
}

make_face(){
  debug make_face "$@"
  local LINE
  local FACE
  array_get DIE_${1:?} FACE
  debug FACE: "${FACE}"
  FACE="${FACE//\// }"
  debug FACE: "${FACE}"

  is_array XDIE_${SIZE}_$1 || array_new XDIE_${SIZE}_$1 $FACE
  eval DIE_LINES=\$XDIE_${SIZE}_${1}_S
}

build_face_list(){
  local die_no=0
  local die_list=''
  array_new DIE_LIST
  while [ $die_no -lt $DICE ] ; do
    debug die_no: $die_no
    : $((die_no++))
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

    make_face "${ROLL}" $die_no
    die_list="${die_list} XDIE_${SIZE}_$ROLL"
    local mod
    debug die_no $die_no PER_LINE $PER_LINE
    : $((mod = die_no % PER_LINE ))
    debug mod $mod
    if [ $mod -eq 0 ] ; then
      array_push DIE_LIST "${die_list}"
      die_list=''
    fi
  done
  if [ -n "${die_list}" ] ; then
    array_push DIE_LIST "${die_list}"
  fi
  debug DIE_LIST: $DIE_LIST
}

show_face_list(){
  local width=0
  do_clear
  echo
  local die_lines="$(seq 1 $DIE_LINES)"
  local fl
  local die_face
  local die_line
  # iterate face lists array element list
  # think we go through die lists here
  # like for bb in die list e
  # array get to var 
  # then do lines, faces from that var
  for dl in $DIE_LIST_E ; do
    debug dl: $dl
    array_get $dl dla
    debug dla: $dla
    for die_line in $die_lines ; do
      for die_face in $dla ; do
        array_get ${die_face}_${die_line} fl
        # replace filler chars with space
        echo -n "${fl//[.:]/ }"
      done
      echo
    done # | sed 's/||/|/g;s/-  -/- -/g' # questionable way to squeeze more in
  done
}

roll(){
  local FORCE=0
  local NOT=0
  local ROLL=0
  local FACE_LIST=''
  local DIE_LIST=''
  local DIE_LINES=0
  while [ $# -gt 0 ] ; do
    case "${1}" in
      (![1-6]) NOT=${1/!} ;;
      ([1-6] ) FORCE=${1} ;;
    esac
    shift
  done
  debug "NOT: ${NOT}"
  debug "FORCE: ${FORCE}"
  get_tty
  debug COLUMNS: $COLUMNS
  build_face_list
  show_face_list

  return ${ROLL}
}

prompt(){
  unset REPLY
  while true ; do
    printf "\rRoll again (${SIZE} x$DICE)? "
    IFS= read -n1 -s REPLY
    debug "REPLY: ${REPLY}"
    case "${REPLY}" in
      ('['   ) : ;; # cursor key suppression
      ([qQnN]) echo ; return 1 ;;
      ([0-9] ) SIZE=$REPLY ; set_die "${SIZE}" ;;
      (M     ) SIZE=mvp ; set_die "${SIZE}" ;;
      (S     ) SIZE=seg ; set_die "${SIZE}" ;;
      (D     ) : $((DICE++)) ;;
      (X     ) [ $DICE -gt 1 ] && : $((DICE--)) ;;
      ([\ -~]) return 0 ;; # all alpha and symbol
    esac
  done
}

set_die(){
  local DIE="$(elaborate ${1})"
  local face_width
  debug "DIE:\n${DIE}"
  array_new DIE ${DIE}
  local first_line="${DIE_1//\/*}"
  debug first_line: "$first_line"
  face_width="${#first_line}"
  debug DIE_S: "${DIE_S}"
  debug DIE_E: "${DIE_E}"
  debug face_width: $face_width
  how_many $face_width
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
  ${DEBUG} || return 0
  printf "## DEBUG ## >>$*<<\n" >&2
}

do_clear(){
  ${TEST} && return
  ${DEBUG} && return
  clear
}

get_tty() {
  local TTY=$(tput -V 1>/dev/null 2>&1 && echo -e "cols\nlines" | tput -S | paste - - || ttysize)
  COLUMNS="${TTY// *}"
  LINES="${TTY//* }"
}

process_params(){
  debug process_params "$@"
  while [ $# -gt 0 ] ; do
    case "${1}" in
      ( [0-9]| [1-9][0-9]) SIZE=${1} ;;
      (x[0-9]|x[1-9][0-9]) DICE=${1/x} ;;
      (s | seg   | -s | --seg  ) SIZE=seg ;;
      (m | mvp   | -m | --mvp  ) SIZE=mvp ;;
      (t | test  | -t | --test ) TEST=true ;;
      (d | debug | -d | --debug) DEBUG=true ;;
      (q | quick | -q | --quick) QUICK=true ;;
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
