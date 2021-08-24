#!/bin/sh

debug(){
  ${DEBUG:-false} || return 0
  printf "## DEBUG ## >>$*<<\n" >&2
}
