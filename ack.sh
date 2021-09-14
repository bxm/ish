#!/usr/bin/env sh

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

usage(){
  echo "$*"
}

non_opt_args(){
  debug non_opt_args "$@"
  # fill rx (if empty), and files with everything else
  [ -z "${EXPRESSION}" ] && EXPRESSION="${1}" && shift
  while [ $# -gt 0 ] ; do
    [ -f "${1}" ] && array_push FILES "${1}"
    [ -d "${1}" ] && array_push DIRS "${1}"
    shift
  done
  debug -v EXPRESSION FILES_S FILES_E
  debug -v DIRS_S DIRS_E
}

process_args(){
  debug process_args "$@"
  CASE=true
  LIST=false
  HEAD=true
  FILEGREP=false
  FANCY=true
  EXPRESSION=''

  local args="$(getopt -n "${RED}warning${_NC_}" -o gHil -- "$@")"
  eval set -- "${args}"
  while [ $# -gt 0 ] ; do
    case "${1}" in
      (--) shift ; break ;;
      (-H) HEAD=false ;;
      (-g) FILEGREP=true ;;
      (-i) CASE=false ;;
      (-l) LIST=true ;;
      (-F) FANCY=false ;;
      (-*) usage "${1} not supported" ;;
    esac
    shift
  done
  non_opt_args "$@"
  debug -v CASE LIST FILEGREP HEAD FANCY
}

# TODO support -g, -l, -i, -hH
# implicit ignore case for -g?
# authentic piped -g w/ -x or "lazy" non piped?
# fancy output? -b option for bare?
# colour inline matches?
list_files(){
  debug list_files "$@"
  local files=$(array_dump FILES)
  local dirs=$(array_dump DIRS)
  find ${files} ${dirs} \
    -type f \
    ! -path */.git/* \
    ! -path */.git | sort -u
  # files and dirs need to be handled differently
  # dirs need to dump out their files, files just
  # are themselves
  # two arrays need to be made during opt handling
}

colour_header(){
  debug colour_header "$@"
  if $HEAD && $FANCY ; then
    awk \
      -v HEAD="$YELLOW" \
      -v LINE="$LRED" \
      -v NC="$_NC_" \
      -v OFS="$BLUE:$_NC_" \
      -F: \
      '{
          sub(/.*/,HEAD"&"NC,$1);
          sub(/.*/,LINE"&"NC,$2);
          print $0
        }'
  else
    cat
  fi
}

grep_in_list(){
  debug grep_in_list "$@"
  local flags=E
  ${LIST} && flags="${flags}l"
  ${CASE} || flags="${flags}i"
  ${HEAD} && flags="${flags}Hn"
  ${HEAD} || flags="${flags}h"
  debug -v flags
  grep -${flags} -- "${EXPRESSION}" $(list_files)
}

main(){
  debug main "$@"
  process_args "$@"
  grep_in_list | colour_header
}

adlib debug decor array

main "$@"
