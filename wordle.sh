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

error(){ 
  printf '%s: %s\n' "${@}" >&2
  exit 1
}

process_args(){
  while [ $# -gt 0 ] ; do
    case "${1}" in
      (-n|--no) no="${no}${2//[^a-zA-Z]}" ;;
      (-y|--yes) yes="${yes}${2//[^a-zA-Z]}" ;;
      (-a|--anti) anti="${anti}${anti:+|}${2}" ;;
      (-p|--pattern) pattern="${2}" ;;
      ([a-z.]*) pattern="${1}" ; shift ; continue ;;
      (/?*) no="${no}${1//[^a-zA-Z]}" ; shift ; continue ;;
      (:?*) yes="${yes}${1//[^a-zA-Z]}" ; shift ; continue ;;
      (@?*) anti="${anti}${anti:+|}${1#@}" ; shift ; continue ;;
      (-s|--spoil) spoil=true ; shift ; continue ;;
    esac
    shift;shift
  done

  [ "${pattern//[A-Za-z.]}" ] && error 'illegal pattern char(s)' "${pattern//[A-Za-z.]}"
  [ "${#pattern}" -gt 5 ] && error 'impossible pattern' "${pattern}"
  [ "${#yes}" -gt 5 ] && error 'impossible yes' "${yes}"
  # check that pattern and anti down overlap
  [ "${pattern//[${no}]}" != "${pattern}" ] && error "conflict" "${pattern}"
  if [ "${anti}" ] ; then
  awk -vp="${pattern}" -va="${anti}" '
    BEGIN {if (p !~ "^"a) {exit 1}}
  ' && error "conflict" "${pattern} / ${anti}"
  fi
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

    # ignore naive check fails
    $0 !~ "[" p "]" {next}

    {
      w = tolower($0)
      for (i in ap) {
        if (w !~ ap[i]) {next}

        # remove from word to test multi
        sub(ap[i], nil, w)
      }
    }

    1
  ' || exit
}

main(){

  debug -f main "$@"
  process_args "${@}"
  grep -Ex .{5} "${realdir}/english-words/words.txt" \
    | grep -vi [^a-z] \
    | grep -vi "[${no:-00000}]" \
    | grep -i "^${pattern:-.}" \
    | grep -viE "^(${anti:-00000})" \
    | agrep "${yes}" \
    | spoiler
}

adlib debug install paths
install

main "$@"

