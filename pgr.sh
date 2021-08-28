get_tty() {
  local tty=$(tput -V 1>/dev/null 2>&1 && echo -e "cols\nlines" | tput -S | paste - - || ttysize)
  local tab=$'\t'
  COLUMNS="${tty//[ ${tab}]*}"
  LINES="${tty//*[ ${tab}]}"
}

nice_clear(){ # clear, preserving scroll back
  local lines=${LINES} # local copy of global
  while [ $(( lines-- )) -gt 1 ] ; do
    echo
  done
  clear
}

prompt(){
  while true ; do
    read -s -n1 -p% <&1
    echo -e "\r \b\c"
    case "${REPLY}" in
      ([qQ]   ) exit ;;
      ($'\r'  ) : $((i-=inc)) ; break ;;
      ([A-D]  ) : $((i-=inc)) ; break ;;
      ([1-9]  ) : $((i-=REPLY)) ; break ;;
      ([hH]   ) PAGE=${HALF} i=0 ; break ;;
      ([fF]   ) PAGE=${FULL} i=0 ; break ;;
      ([a-z\ ]) i=0 ; break ;;
      ([A-Z[] ) continue ;;
      (*      ) continue ;;
    esac
  done
}

set_page_size(){
  #FULL=$(( LINES * 8 / 10)) # actually 80% of tty
  #HALF=$(( LINES * 45 / 100 ))
  FULL=$(( LINES - 2))
  HALF=$(( FULL / 2 ))
  PAGE=${FULL}
}

get_increment(){
  [ $(($1 % COLUMNS)) -eq 0 ]
  local t=$(($1 / COLUMNS + $?))
  [ $t -eq 0 ] && return 1 || return $t
}

get_incrementx(){
  local c="$(echo -n "$1" | clean)"
  [ $((${#c} % COLUMNS)) -eq 0 ]
  local t=$((${#c} / COLUMNS + $?))
  [ $t -eq 0 ] && return 1 || return $t
}

add_length(){
  awk '{n = $0 ; gsub(/\x1B\[[0-9;]*[A-Za-z]/,"",n) ; print length(n),$0}'

}

fix_bslash(){
  sed 's:\\:\\\\:g'
}

read_pipeline(){
  local i=0
  local inc
  local line
  fix_bslash | add_length | while read len line ; do
    get_increment "${len}"
    inc=$?
    : $((i+=inc))
    echo "${line}"
    [ ${i} -lt ${PAGE} ] && continue
    prompt
  done
}

main(){
  # write out to temp file
  # use head/tail to slide around inside
  # to allow back scroll?
  # print current line/total in prompt (rhs it?)
  get_tty
  set_page_size
  nice_clear
  read_pipeline
}

# TODO truncate really long (screenful)?

main "$@"
