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
  local target link
  find "${1}" -mindepth 1 -maxdepth 1 -name 'DOT_*' \
    | while read target ; do
      link="${HOME}/.${target#*/DOT_}"
      target="${target}"
      if [ -e "${link}" -a ! -L "${link}" ] ; then
        echo "Skipped ${link}, exists and not a link"
        continue
      fi
      echo ln -s "${target}" "${link}"
    done
}

reinstalls(){
  grep -E "^install( |$)" "${1}"/*.sh \
    | sed -r 's/^([^:]+):(.*)$/TARG="\1" \2/'

}

main(){
  debug -f main "$@"
  local realname="$(readlink -f "${0}")"
  local realdir="${realname%/*}"
  dot_links "${realdir}"
  reinstalls "${realdir}"
}

adlib debug install

main "$@"

