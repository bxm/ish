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
  if ${LIST} || ! ${HEAD} || ! ${FANCY} ; then
    cat
    return
  fi
  fancy_awk
}

fancy_awk() {
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
      split($0,f,":");                  # split $0
      sub(/^([^:]+:){2}/,"",$0);        # remove $1, $2 from $0
      sub(/[^\/]+$/,_FILE"&"_NC,f[1]);  # colour file part
      gsub(/^.+\/+/,_PATH"&"_NC,f[1]);  # colour path part
      sub(/.*/,_LINE"&"_NC,f[2]);       # colour line number
      gsub(_EXPR,_MATCH"&"_NC,$0);      # colour expression matches
      if (_SINGLE == "true") {          # if single line style
        print f[1],f[2],$0;             #   print filename, line, $0
        next;                           #   move to next record
      }
      if (fn != f[1]) {                 #   if first sight of filename
        print "\n"f[1];                 #     print filename
      }
      print f[2],$0;                    # print line number, $0
      fn=f[1];                          # record filename for next loop
    }'
}

add_flag(){
  flags="${flags}${1}"
}

grep_content(){
  debug grep_content "$@"
  local flags=''
  add_flag "E"
  ${LIST} && add_flag "l"
  ${CASE} || add_flag "i"
  ${HEAD} && add_flag "Hn"
  ${HEAD} || add_flag "h"
  debug -v flags
  case "$EXPR" in
    (.|'.*') list_files ;;
    (*) grep -${flags} -- "${EXPR}" $(list_files)
  esac
}

main(){
  debug main "$@"
  process_args "$@"
  if ${FILEGREP} ; then
    true
  else
    grep_content | make_fancy
  fi
}

adlib debug decor array

main "$@"

