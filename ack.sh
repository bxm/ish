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
  [ -z "$CONTENT_RX" ] && CONTENT_RX="$1" && shift
  array_push FILES "$@"
  debug -v CONTENT_RX FILES_S FILES_E
}

process_args(){
  debug process_args "$@"
  ICASE=false
  LIST=false
  HEAD=true
  FILEGREP=false
  CONTENT_RX=''
  array_new FILES
  local context='DEF'
  local arg
  #while [ $# -gt 0] ; do
    #param="${1}"
# while though -xxx snipping off the flags
# maybe just use getopt?
# eat file/rx params
# handling for -- ?
    #while [ ${#param}
  local args="$(getopt -n "${RED}warning${_NC_}" -o gHil -- "$@")"
  eval set -- "${args}"
  while [ $# -gt 0 ] ; do
    arg="${1}"
    case "${arg}" in
      (--) shift ; break ;;
      (-H) HEAD=false ;;
      (-g) FILEGREP=true ;;
      (-i) ICASE=true ;;
      (-l) LIST=true ;;
      (-*) usage "${arg} not supported" ;; # unhandled opt
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
  find . -mindepth 1 -type f ! -path */.git/* ! -path */.git | sort
}

main(){
  debug main "$@"
  process_args "$@"
}

adlib debug decor array

main "$@"

