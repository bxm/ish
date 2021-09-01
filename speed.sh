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

speed_ping(){
  debug speed_ping "$@"
  SMOOTH=${1:-3}
  ITER=${2:-5}

  debug -v SMOOTH ITER
  while [ ${ITER} -gt 0 ] ; do
    : $((ITER-=1))

    while [ ${SMOOTH} -gt 0 ] ; do
      : $((SMOOTH-=1))
      ping 8.8.8.8 -c 1
      sleep 0.1
    done \
      | grep -oE time=[^\ ]+ \
      | awk -F= '{n+=$NF ; i+=1 ; print $NF,n,i,n/i}'

  done
}

main(){
  debug main "$@"
  case "$1" in
    (ping) shift ; speed_ping "$@" ;;
  esac
}

adlib debug

main "$@"

