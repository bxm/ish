get_tty() {
  local TTY=$(tput -V 1>/dev/null 2>&1 && echo -e "cols\nlines" | tput -S | paste - - || ttysize)
  COLUMNS="${TTY// *}"
  LINES="${TTY//* }"
}

main(){
  i=0
  get_tty
  FULL=$(( LINES * 8 / 10)) # actually 80% of tty
  HALF=$(( LINES * 45 / 100 ))
  # echo $FULL $HALF
  PAGE=$FULL
  while read L ; do
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
      ([a-zA-Z\ ]) i=0 ;;
      (*) : $((i--)) ;;
    esac
  done
}

main "$@"
