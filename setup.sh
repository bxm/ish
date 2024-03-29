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
  debug -f dot_links "$@"
  local target link slash
  find "${1}" -mindepth 1 -maxdepth 1 -name 'DOT_*' \
    | while read target ; do
      link="${HOME}/.${target#*/DOT_}"
      target="${target}"
      if [ -e "${link}" -a ! -L "${link}" ] ; then
        echo "Skipped ${link}, exists and not a link"
        continue
      fi
      if [ -d "${target}" ] ; then
        # ln -f behaviour with directories is ungood
        rm -f "${link}"
        slash=/
      else
        slash=''
      fi
      ${OP} ln -vfs "${target}${slash}" "${link}"
    done
}

bulk_install(){
  debug -f bulk_install "$@"
  grep -E "^install( |$)" "${1}"/*.sh \
    | while IFS=: read targ cmd ; do
        eval ${OP} VERBOSE=true TARG="${targ}" ${cmd}
      done

}

apk_add() {
  debug -f apk_adapk_add "$@"
  ${OP} apk add openssh-client
  ${OP} apk add util-linux
  ${OP} apk add neovim
  ${OP} apk add tmux
}

usage(){
  >&2 echo "Usage: ${0##*/} --op apk|dot|ins|all"
  exit
}

process_params(){
  debug -f process_params "$@"
  DOT=false
  INS=false
  APK=false
  OP=echo
  [ $# -eq 0 ] && usage
  while [ $# -gt 0 ] ; do
    case "${1}" in
      (dot ) DOT=true ;;
      (ins ) INS=true ;;
      (apk ) APK=true ;;
      (all ) DOT=true INS=true APK=true ;;
      (--op) OP="" ;;
      (*) usage ;;
    esac
    shift
  done
  debug -v OP APK DOT INS
  ${APK} || ${DOT} || ${INS}
}

main(){
  debug -f main "$@"
  local realname="$(readlink -f "${0}")"
  local realdir="${realname%/*}"
  process_params "$@" || return
  ${APK} && apk_add
  ${DOT} && dot_links "${realdir}"
  ${INS} && bulk_install "${realdir}"
}

adlib debug install

main "$@"

