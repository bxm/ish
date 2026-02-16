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

agrep(){
  if [ ! "${1}" ] ; then cat ; return ; fi
  awk -vp="${1}" '
    BEGIN {
      nil = ""
      split(tolower(p), ap, "")
    }
    $0 !~ "[" p "]" {next}
    {
      w = tolower($0)
      for (i in ap) {
        if (w !~ ap[i]) {next}
        sub(ap[i], nil, w)
      }
    }
    1
  '
}

main(){

  debug -f main "$@"
  process_args "${@}"
  grep -Ex .{5} "${realdir}/english-words/words.txt" \
    | grep -vi [^a-z] \
    | grep -vi "[${no:-00000}]" \
    | grep -i "^${pattern:-.}" \
    | grep -iE "${two:-.}" \
    | grep -viE "^(${anti:-00000})" \
    | agrep "${yes}" \
    | spoiler
}

adlib debug install paths
install

main "$@"

