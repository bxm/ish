#!/bin/sh

install(){
  debug -f install "$@"
  # allow target override, default to $0
  local TARG="${TARG:-${0}}"
  debug -v TARG
  # get real name of TARG
  local realname="$(readlink -f "${TARG}")"
  if ! test -f "${realname}" ; then
    >&2 echo "WARN: could not install ${TARG}"
    return 1
  fi
  local filename="${realname##*/}"
  debug -v realname filename
  # use params if passed, otherwise snip name
  local linknames="${*:-${filename%.sh}}"
  local installdir="/usr/local/bin"
  mkdir -p "${installdir}"
  debug -v linknames installdir
  local link
  # create symlink to name
  # only override existing symlinks, no other
  for link in ${linknames} ; do
    link="${installdir}/${link}"
    debug -v link
    # only overwrite links
    [ -e "${link}" -a ! -L "${link}" ] && continue
    ln -sf "${realname}" "${link}"
  done
  # also make target executable for good measure
  [ ! -x "${realname}" ] && chmod +x "${realname}"
}

adlib debug


