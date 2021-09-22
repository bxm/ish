#!/bin/sh

###
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
###

prompt(){
  while true ; do
    printf "${WHITE}${INV_ON}%%${_NC_}"
    read -s -n1 <&1
    echo -e "\r           \r\c"
    case "${REPLY}" in
      ([qQ]   ) exit ;;
      ($'\r'  ) : $((drawn-=inc)) ; break ;;
      ([A-D]  ) : $((drawn-=inc)) ; break ;;
      ([1-9]  ) : $((drawn-=REPLY)) ; break ;;
      ([hH]   ) PAGE=${HALF} drawn=0 ; break ;;
      ([fF]   ) PAGE=${FULL} drawn=0 ; break ;;
      ([a-z\ ]) drawn=0 ; break ;;
      ([A-Z[] ) continue ;;
      (*      ) continue ;;
    esac
  done
}

set_page_size(){
  FULL=$(( LINES - 1)) # allow for prompt
  HALF=$(( FULL / 2 ))
  PAGE=${FULL}
}

get_increment(){
  # empty lines need to increment 1
  [ ${1} -eq 0 ] && return 1
  # if wrapped line does not fit exactly in screen
  [ $((${1} % COLUMNS)) -eq 0 ]
  # add 1 to line split by columns - ie rounding up
  local lines=$((${1} / COLUMNS + $?))
  debug lines: ${lines} = ${1} / ${COLUMNS} + 0~1
  return ${lines}
}

prepend_length(){
  # strip colour chars to get visible length
  # prepending value to original text
  awk -v OFS='|' '{n = $0 ; gsub(/\x1B\[[0-9;]*[A-Za-z]/,"",n) ; print length(n),$0}'
}

fix_bslash(){
  sed 's:\\:\\\\:g'
}

read_pipeline(){
  local drawn=0 # how far down a page we have drawn
  local inc
  local line
  fix_bslash | prepend_length | while IFS='|' read len line ; do
    echo "${line}"
    debug len: ${len}
    get_increment "${len}"
    inc=$? # used in prompt func
    # ostensibly adding 1 per line, but counting
    # wrapped lines as more, so as not to overscroll
    : $((drawn+=inc))
    # only prompt if we have filled the screen
    [ ${drawn} -lt ${PAGE} ] && continue
    prompt
  done
}

check_params(){
  [ $# -eq 0 ] && return 1

  while [ $# -gt 0 ] ; do
    [ -f "$1" ] || continue
    cat "$1" | "$0"
    [ $# -le 1 ] && exit
    printf "${LRED}${INV_ON}%%${_NC_}"
    read -s -n1
    echo -e "\r           \r\c"
    case "$REPLY" in
      ([qQ]) exit ;;
    esac
    shift
  done
}

main(){
  # write out to temp file
  # use head/tail to slide around inside
  # to allow back scroll?
  # print current line/total in prompt (rhs it?)

  # what if read whole input to array?
  # would be slow to start if did whole thing.
  # but loading on demand might work..
  # app memory limit?
  # how to manage navigating .. would need to know
  # index for top line of screen as that is redraw
  # point, if pressing up arrow or like 'b' for screen
  # get top with :: bottom row index - (FULL-1)
  #
  get_tty
  set_page_size
  nice_clear 1
  check_params "$@" || read_pipeline
}

# TODO truncate really long (screenful)?
adlib debug tty array decor

main "$@"
