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
  PAGE=$FULL
  sed 's:\\:\\\\:g' | while read L ; do
    : $((i++))
    echo "${L:- }"
    [ $i -lt $PAGE ] && continue
    read -s -n1 -p% <&1
    echo -e "\r\c"
    case "$REPLY" in
      ([qQ]) break ;;
      ([1-9]) : $((i-=REPLY)) ;;
      ([hH]) PAGE=$HALF i=0 ;;
      ([fF]) PAGE=$FULL i=0 ;;
      ([a-z\ ]) i=0 ;;
      (*) : $((i--)) ;; # need to do something with arrow keys like in dice
    esac
  done
}

main "$@"
