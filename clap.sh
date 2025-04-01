#!/bin/sh

set -e

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
    echo repo here, fetching
    git fetch
  else
    echo no repo, cloning
    git clone git@bitbucket.org:bxm/clap-cnc.git .
  fi
}

main(){
  debug -f main "$@"
  local repo="${HOME}/clap-cnc"
  ensure_repo
  case "${mode:=cmd}" in
    (cmd)
      git checkout cmd
      printf '"%s" ' "${@}"
      # start with a single command, but we should be able to stage multiple
      # in subordinate mode we should take the sha1 of the cmd commit, and create a new branch from master (damn made the repo wrong) containing names for datetime andbthe sha1, command responses should be placed in file/files in there

  esac
  mode_action "${@}"

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

