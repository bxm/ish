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
  [ -z "${EXPRESSION}" ] && EXPRESSION="${1}" && shift
  array_push FILES "$@"
  debug -v EXPRESSION FILES_S FILES_E
}

process_args(){
  debug process_args "$@"
  ICASE=false
  LIST=false
  HEAD=true
  FILEGREP=false
  EXPRESSION=''
  array_new FILES

  local args="$(getopt -n "${RED}warning${_NC_}" -o gHil -- "$@")"
  eval set -- "${args}"
  while [ $# -gt 0 ] ; do
    case "${1}" in
      (--) shift ; break ;;
      (-H) HEAD=false ;;
      (-g) FILEGREP=true ;;
      (-i) ICASE=true ;;
      (-l) LIST=true ;;
      (-*) usage "${1} not supported" ;;
    esac
    shift
  done
  non_opt_args "$@"
  debug -v ICASE LIST FILEGREP HEAD
}

# TODO support -g, -l, -i, -hH
# implicit ignore case for -g?
# authentic piped -g w/ -x or "lazy" non piped?
# fancy output? -b option for bare?
# colour inline matches?
list_files(){
  local files=$(array_dump FILES | sort -u)
  find $files -mindepth 1 -type f ! -path */.git/* ! -path */.git | sort
  # files and dirs need to be handled differently
  # dirs need to dump out their files, files just
  # are themselves
  # two arrays need to be made during opt handling
}

main(){
  debug main "$@"
  process_args "$@"
  $LIST && list_files
}

adlib debug decor array

main "$@"

