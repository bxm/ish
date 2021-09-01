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
  smooth=$SMOOTH

  debug -v SMOOTH ITER
  while [ ${ITER} -gt 0 ] ; do
    : $((ITER-=1))

    while [ ${SMOOTH} -gt 0 ] ; do
      : $((SMOOTH-=1))
      ping 8.8.8.8 -c 1
      sleep 0.1
    done \
      | grep -oE time=[^\ ]+ \
      | awk -v "max=$smooth" -F= '{n+=$NF ; i+=1 ; if (i==max) {print int(n/i)}}' | bar 15
      #| awk -F= '{n+=$NF ; i+=1 ; print $NF,n,i,n/i}'

  done
}

speed_dl(){
  debug speed_dl "$@"
  local url=''
  case "${1:-small}" in
    (s*) url='http://example.com/' ;;
    (m*) url='http://speedtest.tele2.net/1MB.zip' ;;
    (l*) url='http://212.183.159.230/5MB.zip' ;;
  esac
  debug -v url
  : "${url:?}"
  unset REPLY
  while read -s -n1 -t0.2 REPLY || true ; do
    debug -v REPLY
    [ "${REPLY}" = q ] && break
    time wget "$url" -T3 -o /dev/null -O /dev/null 2>&1 | grep real
  done | awk '{gsub(/s/,"",$NF); print $NF}'
}

bar(){
  debug bar "$@"
  local count
  local floor="${1:-0}"
  local col=$((COLUMNS+floor-5))
  while read count ; do
    printf "%4s " "$count"
    [ $count -gt $col ] && count=$col
    while [ $count -gt $floor ] ; do
      echo -n "#"
      : $((count=count * 95 / 100))
    done
    echo
  done
}
main(){
  debug main "$@"
  get_tty
  case "${1}" in
    (p|ping) shift ; speed_ping "$@" ;;
    (d|dl  ) shift ; speed_dl   "$@" ;;
  esac
}

adlib debug tty

main "$@"

