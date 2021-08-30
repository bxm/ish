#!/usr/bin/env sh

debug(){
  ${DEBUG:-false} || return 0
  printf "## DEBUG ## >>%s<<\n" "$*" >&2
}
