#!/bin/sh

adlib(){
  local realname="$(readlink -f "${0}")"
  local libdir="${realname%/*}/lib"
	while [ $# -gt 0 ] ; do
		local libname="${1%.sh}.sh"
		source "${libdir}/${libname}" || continue
    debug added "${libdir}/${libname}"
		shift
	done
}

usage(){
  exec >&2
  printf "${*:+${LRED}ERROR: ${*}${_NC_}\n\n}"
cat << EOF
Usage: ${0//*\/} [options] expression [files]

-F  suppress fancy output
-H  suppress header
-g  pattern match in file list
-h  this help text
-i  ignore pattern case
-l  list files only
-s  single line fancy output
-x  read files from pipeline

EOF
  exit ${1//*/1}
}

non_opt_args(){
  debug -f non_opt_args "$@"
  # fill rx (if empty), and files with everything else
  [ -z "${EXPR}" ] && EXPR="${1}" && shift
  while [ $# -gt 0 ] ; do
    if [ -f "${1}" ] ; then
      array_push FILES "${1}"
    elif [ -d "${1}" ] ; then
      array_push DIRS "${1}"
    else
      array_push OTHER "${1}"
    fi
    shift
  done
  debug -v EXPR FILES_S FILES_E
  debug -v DIRS_S DIRS_E
  debug -v OTHER_S OTHER_E
}

process_args(){
  debug -f process_args "$@"
  : "${DEBUG:=false}"
  CASE=true
  LIST=false
  HEAD=true
  FILEGREP=false
  FANCY=true
  SINGLE=false
  PIPELIST=false
  EXPR=''

  local args="$(getopt -n "${RED}warning${_NC_}" -o FHdghilsx -- "$@")"
  eval set -- "${args}"
  while [ $# -gt 0 ] ; do
    case "${1}" in
      (--) shift ; break ;;
      (-F) FANCY=false ;;
      (-H) HEAD=false ;;
      (-d) DEBUG=true ;;
      (-g) FILEGREP=true ;;
      (-h) usage ;;
      (-i) CASE=false ;;
      (-l) LIST=true ;;
      (-s) SINGLE=true ;;
      (-x) PIPELIST=true ;;
      (-*) usage "${1} not supported" ;;
    esac
    shift
  done
  non_opt_args "$@"
  [ "${EXPR}" ] || usage "no expression given"
  debug -v CASE LIST FILEGREP HEAD FANCY
}

list_files(){
  debug -f list_files "$@"
  local files=$(array_dump FILES)
  local dirs=$(array_dump DIRS)
  [ $((FILES_S + DIRS_S)) -eq 0 -a $((OTHER_S)) -gt 0 ] && usage "no valid files/dirs given"

  find ${files} ${dirs} \
    -type f \
    ! -path */.git/* \
    ! -path */.git \
    | sort -u \
    | sed 's|^[.]/||'
}

piped_files(){
  debug -f piped_files "$@"
  cat
}

make_fancy(){
  debug -f make_fancy "$@"
  if ${LIST} || ! ${HEAD} || ! ${FANCY} ; then
    cat
    return
  fi
  fancy_awk
}

fancy_awk() {
  debug -f fancy_awk "$@"
  awk \
    -v _FILE="${YELLOW}" \
    -v _PATH="${BROWN}" \
    -v _LINE="${LRED}" \
    -v _MATCH="${LCYAN}${INV_ON}" \
    -v _EXPR="${EXPR}" \
    -v _NC="${_NC_}" \
    -v _SINGLE="${SINGLE}" \
    -v OFS="${WHITE}:${_NC_}" \
    '{
      split($0,f,":");                 # split $0
      sub(/^([^:]+:){2}/,"",$0);       # kill $1, $2
      sub(/[^\/]+$/,_FILE"&"_NC,f[1]); # colour file
      gsub(/^.+\/+/,_PATH"&"_NC,f[1]); # colour path
      sub(/.*/,_LINE"&"_NC,f[2]);      # colour line
      gsub(_EXPR,_MATCH"&"_NC,$0);     # colour match
      if (_SINGLE == "true") {         # single style
        print f[1],f[2],$0;            # file line $0
        next;                          #   next record
      }
      if (fn != f[1]) {                # first sight of filename
        print "\n"f[1];                #   prnt file
      }
      print f[2],$0;                   # line $0
      fn=f[1];                         # record file
    }'
}

add_flag(){
  debug -f add_flag "$@"
  flags="${flags}${1}"
}

grep_content(){
  debug -f grep_content "$@"
  local flags=''
  add_flag "E"
  ${LIST} && add_flag "l"
  ${CASE} || add_flag "i"
  ${HEAD} && add_flag "Hn"
  ${HEAD} || add_flag "h"
  debug -v flags
  if ${PIPELIST} ; then
    piped_files
  else
    list_files
  fi \
    | xargs -r grep -${flags} -- "${EXPR}"
}

grep_list(){
  debug -f "grep_list" "$@"
  local flags=''
  add_flag "E"
  ${CASE} || add_flag "i"
  list_files \
    | grep -${flags} -- "${EXPR}"
}

main(){
  debug -f main "$@"
  process_args "$@"
  debug -f main "$@"
  if ${FILEGREP} ; then
    grep_list
  else
    grep_content | make_fancy
  fi
  debug -f main.END "$@"
}

adlib debug decor array

main "$@"

