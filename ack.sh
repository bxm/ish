#!/usr/bin/env sh

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
-g  not implemented
-h  this help text
-i  ignore pattern case
-l  list files only
-s  single line fancy output

EOF
  exit ${1//*/0}
}

non_opt_args(){
  debug non_opt_args "$@"
  # fill rx (if empty), and files with everything else
  [ -z "${EXPR}" ] && EXPR="${1}" && shift
  while [ $# -gt 0 ] ; do
    [ -f "${1}" ] && array_push FILES "${1}"
    [ -d "${1}" ] && array_push DIRS "${1}"
    shift
  done
  debug -v EXPR FILES_S FILES_E
  debug -v DIRS_S DIRS_E
}

process_args(){
  debug process_args "$@"
  CASE=true
  LIST=false
  HEAD=true
  FILEGREP=false
  FANCY=true
  SINGLE=false
  EXPR=''

  local args="$(getopt -n "${RED}warning${_NC_}" -o FHghils -- "$@")"
  eval set -- "${args}"
  while [ $# -gt 0 ] ; do
    case "${1}" in
      (--) shift ; break ;;
      (-F) FANCY=false ;;
      (-H) HEAD=false ;;
      (-g) FILEGREP=true ;;
      (-h) usage ;;
      (-i) CASE=false ;;
      (-l) LIST=true ;;
      (-s) SINGLE=true ;;
      (-*) usage "${1} not supported" ;;
    esac
    shift
  done
  non_opt_args "$@"
  [ "${EXPR}" ] || usage "no expression given"
  debug -v CASE LIST FILEGREP HEAD FANCY
}

# TODO support -g, -l, -i, -hH
# implicit ignore case for -g?
# authentic piped -g w/ -x or "lazy" non piped?
list_files(){
  debug list_files "$@"
  local files=$(array_dump FILES)
  local dirs=$(array_dump DIRS)
  find ${files} ${dirs} \
    -type f \
    ! -path */.git/* \
    ! -path */.git \
    | sort -u \
    | sed 's|^[.]/||'
}

make_fancy(){
  debug make_fancy "$@"
  ${LIST} && cat && return
  ! ${HEAD} && cat && return
  ! ${FANCY} && cat && return
  ${SINGLE} && fancy_single_line && return
  fancy_multi_line
}

fancy_multi_line() {
  awk \
    -v _FILE="${YELLOW}" \
    -v _LINE="${LRED}" \
    -v _MATCH="${LCYAN}${INV_ON}" \
    -v _EXPR="${EXPR}" \
    -v _NC="${_NC_}" \
    -v OFS=: \
    '{
      split($0,f,":");
      gsub(_EXPR,_MATCH"&"_NC,$0);
      sub(/^([^:]+:){2}/,"",$0);
      sub(/.*/,_FILE"&"_NC,f[1]);
      if (fn != f[1]) {
        print "\n"f[1];
      }
      sub(/.*/,_LINE"&"_NC,f[2]);
      print f[2],$0;
      fn=f[1];
    }'
}

fancy_single_line() {
  awk \
    -v _FILE="${YELLOW}" \
    -v _PATH="${BROWN}" \
    -v _LINE="${LRED}" \
    -v _MATCH="${LCYAN}${INV_ON}" \
    -v _EXPR="${EXPR}" \
    -v _NC="${_NC_}" \
    -v OFS="${WHITE}:${_NC_}" \
    '{
      split($0,f,":");
      sub(/[^\/]+$/,_FILE"&"_NC,f[1]);
      gsub(/^.+\/+/,_PATH"&"_NC,f[1]);
      sub(/.*/,_LINE"&"_NC,f[2]);
      sub(/^([^:]+:){2}/,"",$0);
      gsub(_EXPR,_MATCH"&"_NC,$0);
      print f[1],f[2],$0
    }'
}

add_flag(){
  flags="${flags}${1}"
}

grep_in_list(){
  debug grep_in_list "$@"
  local flags=''
  add_flag "E"
  ${LIST} && add_flag "l"
  ${CASE} || add_flag "i"
  ${HEAD} && add_flag "Hn"
  ${HEAD} || add_flag "h"
  debug -v flags
  grep -${flags} -- "${EXPR}" $(list_files)
}

main(){
  debug main "$@"
  process_args "$@"
  grep_in_list | make_fancy
}

adlib debug decor array

main "$@"

