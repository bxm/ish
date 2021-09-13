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

process_args(){
  debug process_args "$@"
  ICASE=false
  LIST=false
  HEAD=true
  local opt
  #while [ $# -gt 0] ; do
    #param="$1"
# while though -xxx snipping off the flags
# maybe just use getopt?
# eat file/rx params
# handling for -- ?
    #while [ ${#param}

  for opt in $(getopt -ghil -- "$@")
    case "$o" in
      (-i) ICASE=true ;;
      (-l) LIST=true ;;
      (-H) HEAD=false ;;
    esac
  done
}

# TODO support -g, -l, -i, -hH
# implicit ignore case for -g?
# authentic piped -g w/ -x or "lazy" non piped?
# fancy output? -b option for bare?
# colour inline matches?

main(){
  debug main "$@"
  find . -mindepth 1 -type f ! -path */.git/* ! -path */.git | sort
}

adlib debug decor

main "$@"

