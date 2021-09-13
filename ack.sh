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

process_args(){
  debug process_args "$@"
  ICASE=false
  LIST=false
  HEAD=true
  FILEGREP=false
  local context='GEN'
  local opt
  #while [ $# -gt 0] ; do
    #param="$1"
# while though -xxx snipping off the flags
# maybe just use getopt?
# eat file/rx params
# handling for -- ?
    #while [ ${#param}
  local args="$(getopt -ghil -- "$@")"
  set -- ${args}
  while [ $# -gt 0 ] ; do
    case "${context}/${opt}" in
      (GEN/-h ) HEAD=false ;;
      (GEN/-g ) FILEGREP=true ;;
      (GEN/-i ) ICASE=true ;;
      (GEN/-l ) LIST=true ;;
      (GEN/-- ) context=PARAM ;;
      (GEN/-* )  ;; # unhandled opt
      (GEN/*  )  ;; # grab danglers as rx, files
      (PARAM/*)  ;; # in PARAM context fill rx (if empty), and files with everything else
        # TODO do something with non opt args?
        # The norm actually seem to be to break on -- and I guess
        # have another routine for files etc but going it with
        # context seems better, so we can handle danglers
    esac
  done
}

# TODO support -g, -l, -i, -hH
# implicit ignore case for -g?
# authentic piped -g w/ -x or "lazy" non piped?
# fancy output? -b option for bare?
# colour inline matches?
list_files(){
  find . -mindepth 1 -type f ! -path */.git/* ! -path */.git | sort
}

main(){
  debug main "$@"
}

adlib debug decor

main "$@"

