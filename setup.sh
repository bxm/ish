#!/bin/sh

adlib(){
  local realname="$(readlink -f "${0}")"
  local libdir="${realname%/*}/lib"
  while [ $# -gt 0 ] ; do
    local libname="${1%.sh}.sh"
    source "${libdir}/${libname}" || continue
    debug added "${libdir}/${libname}"
    shift
  done
}

dot_links(){
  local realname="$(readlink -f "${0}")"
  local realdir="${realname%/*}"
  local target link
  find . -mindepth 1 -maxdepth 1 -name 'DOT_*' \
    | while read target ; do
      link="$HOME/.${target#./DOT_}"
      target="$PWD/${target#./}"
      if [ -e "$link" -a ! -L "$link" ] ; then
        echo "Skipped $link, exists and not a link"
        continue
      fi
      echo ln -s $target $link
    done
}

find_installs(){
  true
}

main(){
  debug -f main "$@"
  dot_links "$@"
}

adlib debug install

main "$@"

