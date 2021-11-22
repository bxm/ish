cd(){
  case "$1" in
    (projects|projects/*)
      local dir="$1"
      shift
      command cd "/some/dir/${dir}" "$@"  ;;
    (*)
      command cd "$@" ;;
  esac
}
