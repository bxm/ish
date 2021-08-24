get_tty() {
  local TTY=$(tput -V 1>/dev/null 2>&1 && echo -e "cols\nlines" | tput -S | paste - - || ttysize)
  local TAB=$'\t'
  COLUMNS="${TTY//[ ${TAB}]*}"
  LINES="${TTY//*[ ${TAB}]}"
}

main(){
  i=0
  get_tty
  FULL=$(( LINES * 8 / 10)) # actually 80% of tty
  HALF=$(( LINES * 45 / 100 ))
  PAGE=${FULL}
  sed 's:\\:\\\\:g' | while read L ; do
    : $((i++))
    echo "${L:- }"
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
