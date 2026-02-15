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

process_args(){
  while [ $# -gt 0 ] ; do
    case "${1}" in
      (-n|--no) no="${no}${2}" ;;
      (-y|--yes) yes="${yes}${2}" ;;
      (-p|--pattern) pattern="${2}" ;;
      ([a-z.]*) pattern="${1}" ; shift ; continue ;;
      (-s|--spoil) spoil=true ; shift ; continue ;;
    esac
    shift;shift
  done
}

spoiler(){
  if "${spoil:-false}" ; then
    cat
  else
    wc -l
  fi
}

# yes needs to ensure each letter
# is a match, not just any
# could have a recursive func 

main(){

  debug -f main "$@"
  process_args "${@}"
  grep ..... -x english-words/words.txt \
    | grep -v [^a-z] \
    | grep "[${yes:-a-z}]" \
    | grep -v "[${no:-0}]" \
    | grep "^${pattern:-.....}" \
    | spoiler
}

adlib debug install
install

main "$@"

