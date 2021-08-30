#!/usr/bin/env sh

adlib(){
  local realname="$(readlink -f "$0")"
  local libdir="${realname%/*}/lib"
	while [ $# -gt 0 ] ; do
		local libname="${1%.sh}.sh"
		source "$libdir/$libname" || continue
    debug added "$libdir/$libname"
		shift
	done
}

main(){
  debug main "$@"
}

adlib debug

main "$@"