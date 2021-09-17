#!/bin/sh

debug(){
  ${DEBUG:-false} || return 0
  case "${1}" in
    (-f)
      local func="$2"
      shift 2
      debug "${RED}${func}${BLUE} $*${_NC_}"
      ;;
    (-v)
      shift
      while [ $# -gt 0 ] ; do
        eval debug "${1}: \>\>\$${1}\<\<"
        shift
      done
      ;;
    (* )

      printf "## DEBUG [$(pid_colour)$$${_NC_}] ## %s\n" "$*" >&2 ;;
  esac
}

pid_colour() {
  local cols='LGREY BLUE BROWN LBLUE GREEN LCYAN GREY LPURPLE RED WHITE LRED CYAN YELLOW PURPLE '
  set -- ${cols}
  local pidmod=$(($$ % $# + 1))
  eval col=\$${pidmod}
  eval COL_PID_$$=\$${col}
  eval printf "\${COL_PID_$$}"
}

