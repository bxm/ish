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

sleepy(){
  debug sleepy "$@"
  local sleep_time="${1:-1}"
  local reply
  debug -v sleep_time
  read -s -n1 -t${sleep_time} reply
  debug -v REPLY
  ! [ "${reply}" = q ]
}

bar(){
  debug bar "$@"
  local count
  local floor="${1:-0}"
  local reduction="${2:-97}"
  local col=$(((COLUMNS+floor)-5))
  debug -v COLUMNS col floor reduction
  while read count ; do
    printf "%4s " "${count}"
    #[ ${count} -gt ${col} ] && count=${col}
    while [ ${count} -gt ${floor} ] ; do
      printf "#"
      : $((count=(count * reduction) / 100))
      debug -v count
      #: $((count--))
    done
    printf "\n"
  done | cut -c 1-${COLUMNS}
}

speed_ping(){
  debug speed_ping "$@"
  SMOOTH=${1:-3}
  ITER=${2:-5}
  smooth=${SMOOTH}

  debug -v SMOOTH ITER
  while [ ${ITER} -ne 0 ] ; do
    : $((ITER-=1))

    sleepy 1 || break
    while [ ${SMOOTH} -gt 0 ] ; do
      : $((SMOOTH-=1))
      ping 8.8.8.8 -c 1
    done \
      | grep -oE time=[^\ ]+ \
      | awk -v "max=${smooth}" -F= '{n+=$NF ; i+=1 ; if (i==max) {print int(n/i)}}' | bar 25 90
      #| awk -F= '{n+=$NF ; i+=1 ; print $NF,n,i,n/i}'

  done
}

speed_dl(){
  debug speed_dl "$@"
  local url=''
  local min=0
  local red=''
  case "${1:-small}" in
    (s*) url='http://example.com/' ;;
    (m*) url='http://speedtest.tele2.net/1MB.zip' min=25 red=95 ;;
    (l*) url='http://212.183.159.230/5MB.zip' min=35 red=90 ;;
  esac
  debug -v url
  : "${url:?}"
  while sleepy 1 ; do
    time wget "${url}" -T3 -o /dev/null -O /dev/null 2>&1 | grep real
  done | awk '{gsub(/s/,"",$NF); print $NF*100}' | bar ${min} ${red}
}

main(){
  debug main "$@"
  get_tty
  case "${1}" in
    (p*) shift ; speed_ping "$@" ;;
    (d*) shift ; speed_dl   "$@" ;;
  esac
}

adlib debug tty

main "$@"

