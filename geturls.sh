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

get_urls(){
  cat "$@" | grep -Eo "\<https?://[^[:space:]]+"
}

edit(){
  true call editor on tmp file
}
main(){
  debug -f main "$@"
  # TODO
  # add switch to show and/or copy
  # or just show them anyway, add a quiet flag?
  # write to mktemp file
  # run through editor
  # cat temp file into clipboard
  # trap exit to clean up temp file
  # make edit optional
  get_urls "$@" | tee /dev/clipboard
}

adlib debug install

install

main "$@"

