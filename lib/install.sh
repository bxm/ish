#!/bin/sh

install(){
  debug -f install "$@"
  # get real name of dollar zero
  local realname="$(readlink -f "${0}")"
  local filename="${realname##*/}"
  debug -v realname filename
  # if no param passed, snip name only
  # otherwise use params
  local linknames="${*:-${filename%.sh}}"
  local installdir="/usr/local/bin"
  debug -v linknames installdir
  local l
  # create symlink to name
  # only override existing symlinks, no other
  for l in ${linknames} ; do
    l="${installdir}/${l}"
    debug -v l
    [ -e "${l}" -a ! -L "${l}" ] && continue
    ln -sf "${realname}" "${l}"
  done
  # also make sure executable for good measure
  [ ! -x "${realname}" ] && chmod +x "${realname}"
}

adlib debug


