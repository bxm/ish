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
      (-2|--two) two="${two}${two:+|}.*${2}.*${2}" ;;
      (-n|--no) no="${no}${2}" ;;
      (-y|--yes) yes="${yes}${2}" ;;
      (-a|--anti) anti="${anti}${anti:+|}${2}" ;;
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
# two needs to do similar

main(){

  debug -f main "$@"
  process_args "${@}"
  grep ..... -x "${realdir}/english-words/words.txt" \
    | grep -vi [^a-z] \
    | grep -i "[${yes:-a-z}]" \
    | grep -vi "[${no:-0}]" \
    | grep -i "^${pattern:-.}" \
    | grep -iE "${two:-.}" \
    | grep -viE "^(${anti:-0})" \
    | spoiler
}

adlib debug install paths
install

main "$@"

