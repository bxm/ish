#!/usr/bin/env sh

#adlib(){
#  local realname="$(readlink -f "$0")"
#  local libdir="${realname%/*}/lib"
#	while [ $# -gt 0 ] ; do
#		local libname="${1%.sh}.sh"
#		source "$libdir/$libname" || continue
#    debug added "$libdir/$libname"
#		shift
#	done
#}
#
#DEBUG=true
#adlib debug
#DEBUG=true debug foo
#
(return 0) && sourced=true || sourced=false
cat /proc/$$/cmdline | grep -oE "[\ -~]+"
