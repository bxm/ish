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
  while [ $# -gt 0] ; do
    case "$1" in
      (-i) ICASE=true ;;
    esac
    shift
  done
}

main(){
  debug main "$@"
  # TODO support -g, -l, -i, -hH
  # implicit ignore case for -g?
  # authentic piped -g w/ -x or "lazy" non piped?
  # fancy output? -b option for bare?
  # colour inline matches?
  find . -mindepth 1 -type f ! -path */.git/* ! -path */.git | sort
}

adlib debug decor

main "$@"

