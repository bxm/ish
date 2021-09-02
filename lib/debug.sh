#!/bin/sh

debug(){
  ${DEBUG:-false} || return 0
  case "$1" in
    (-v)
      shift
      while [ $# -gt 0 ] ; do
        eval debug "$1: \$$1"
        shift
      done
      ;;
    (* ) printf "## DEBUG ## >>%s<<\n" "$*" >&2 ;;
  esac
}
