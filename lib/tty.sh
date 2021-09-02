#!/bin/sh

get_tty() {
  local tty=$(tput -V 1>/dev/null 2>&1 && printf "cols\nlines" | tput -S | paste - - || ttysize)
  local tab=$'\t' # NOTE this no worky with proper sh?
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

