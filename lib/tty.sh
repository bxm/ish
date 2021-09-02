#!/bin/sh

get_tty() {
  local tty=$(tput -V 1>/dev/null 2>&1 && echo -e "cols\nlines" | tput -S | paste - - || ttysize)
  local tab=$'\t'
  COLUMNS="${tty//[ ${tab}]*}"
  LINES="${tty//*[ ${tab}]}"
}

nice_clear(){ # clear, preserving scroll back
  local lines=${LINES} # local copy of global
  while [ $(( lines-- )) -gt ${1:-0} ] ; do
    echo
  done
  clear
}

