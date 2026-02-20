#!/bin/sh

adlib(){
  local realname
  realname="$(readlink -f "${0}")"
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
      (-n|--no) spoil=false ; no="${no}${2//[^a-zA-Z]}" ;;
      (-y|--yes) spoil=false ; yes="${yes}${2//[^a-zA-Z]}" ;;
      (-a|--anti) spoil=false ; anti="${anti}${anti:+|}${2}" ;;
      (-p|--pattern) spoil=false ; pattern="${2}" ;;
      ([a-z.]*) spoil=false ; pattern="${1}" ; shift ; continue ;;
      (/?*) spoil=false ; no="${no}${1//[^a-zA-Z]}" ; shift ; continue ;;
      (:?*) spoil=false ; yes="${yes}${1//[^a-zA-Z]}" ; shift ; continue ;;
      (@?*) spoil=false ; anti="${anti}${anti:+|}${1#@}" ; shift ; continue ;;
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
    BEGIN {if (p !~ "^(" a ")") {exit 1}}
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

# compile all the @ into an array
# each element contains the @ letters
# for positions 1 to 5
# use each position as a neg filter
# against each word, one at a time
# no ... just reform @aa..b into a bunch of
# single letter filters like a|.a|....b|etc
# and just neg match it once with grep -Evi

agrep2(){
  :
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

get_word_list(){
  [ -e "${word_list}" ] && return
  curl -Ss -o \
    "${realdir}/words.txt" \
    https://raw.githubusercontent.com/dwyl/english-words/refs/heads/master/words.txt
}

main(){

  debug -f main "$@"
  local word_list="${realdir}/words.txt"
  process_args "${@}"

  get_word_list || return

  grep -Ex .{5} "${word_list}" \
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

