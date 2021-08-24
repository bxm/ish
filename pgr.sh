get_tty() {
  local tty=$(tput -V 1>/dev/null 2>&1 && echo -e "cols\nlines" | tput -S | paste - - || ttysize)
  local tab=$'\t'
  COLUMNS="${tty//[ ${tab}]*}"
  LINES="${tty//*[ ${tab}]}"
}

nice_clear(){ # clear, preserving scroll back
  local LINES # local of global
  while [ $(( LINES-- )) -gt 1 ] ; do
    echo
  done
  clear
}

main(){
  local i=0
  local line
  get_tty
  FULL=$(( LINES * 8 / 10)) # actually 80% of tty
  HALF=$(( LINES * 45 / 100 ))
  PAGE=${FULL}
  # write out to temp file
  # use head/tail to slide around inside
  # to allow back scroll?
  # print current line/total in prompt (rhs it?)

  nice_clear

  sed 's:\\:\\\\:g' | while read line ; do
    : $((i++))
    echo "${line:- }" # space to cover % prompt
    [ ${i} -lt ${PAGE} ] && continue
    while true ; do
      read -s -n1 -p% <&1
      echo -e "\r\c"
      case "${REPLY}" in
        ([qQ]) break 2 ;;
        ($'\r') : $((i--)) ; break ;;
        ([A-D]) : $((i--)) ; break ;;
        ([1-9]) : $((i-=REPLY)) ; break ;;
        ([hH]) PAGE=${HALF} i=0 ; break ;;
        ([fF]) PAGE=${FULL} i=0 ; break ;;
        ([a-z\ ]) i=0 ; break ;;
        ([A-Z[]) : ;;
        (*) : ;; #$((i--)) ; break ;;
      esac
    done
  done
}

main "$@"
