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

ensure_repo(){
  mkdir -p "${repo}"
  cd "${repo}"
  if [ -e .git ] ; then
    git fetch
  else
    git clone git@bitbucket.org:bxm/clap.git .
  fi
}

main(){
  debug -f main "$@"
  repo="${home}/clap"
  # in git repo
  # pull branch
  # check file
  # perform action
  # save command and output to timestamped log/logs
  # submit content to another branch on repo
  # set file to None
  # we saved record elsewhere, so do we reset branch?

}

adlib debug install

main "$@"

