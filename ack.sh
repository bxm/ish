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
  echo "$*"
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
  EXPR=''

  local args="$(getopt -n "${RED}warning${_NC_}" -o gHil -- "$@")"
  eval set -- "${args}"
  while [ $# -gt 0 ] ; do
    case "${1}" in
      (--) shift ; break ;;
      (-H) HEAD=false ;;
      (-g) FILEGREP=true ;;
      (-i) CASE=false ;;
      (-l) LIST=true ;;
      (-F) FANCY=false ;;
      (-*) usage "${1} not supported" ;;
    esac
    shift
  done
  non_opt_args "$@"
  debug -v CASE LIST FILEGREP HEAD FANCY
}

# TODO support -g, -l, -i, -hH
# implicit ignore case for -g?
# authentic piped -g w/ -x or "lazy" non piped?
# fancy output? -b option for bare?
# colour inline matches?
list_files(){
  debug list_files "$@"
  local files=$(array_dump FILES)
  local dirs=$(array_dump DIRS)
  find ${files} ${dirs} \
    -type f \
    ! -path */.git/* \
    ! -path */.git | sort -u
  # files and dirs need to be handled differently
  # dirs need to dump out their files, files just
  # are themselves
  # two arrays need to be made during opt handling
}

make_fancy(){
  debug make_fancy "$@"
# do something like check $1 against a var
# if not matched, print $1 then content beneath
# plaxe ${1} in the var and proceed to next line
  if ${HEAD} && ${FANCY} ; then
    awk \
      -v _FILE="${YELLOW}" \
      -v _LINE="${LRED}" \
      -v _MATCH="${LCYAN}${INV_ON}" \
      -v _EXPR="${EXPR}" \
      -v _NC="${_NC_}" \
      -v OFS=: \
      '{
         split($0,f,":");
         sub(/.*/,_FILE"&"_NC,f[1]);
         sub(/.*/,_LINE"&"_NC,f[2]);
         sub(/^([^:]+:){2}/,"",$0);
         gsub(_EXPR,_MATCH"&"_NC,$0);
         print f[1],f[2],$0
       }'
  else
    cat
  fi
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

