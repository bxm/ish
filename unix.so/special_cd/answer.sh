cd(){
  local dir=''
  local input="${1}/"
  case "${input}" in
    (projects/*) dir="/some/dir/$input" ;;
    (:/*)        dir="/some/dir/projects/${input#*/}" ;;
    (*)
      command cd "$@"
      return
      ;;
  esac
  shift
  command cd "${dir}" "$@"
}
