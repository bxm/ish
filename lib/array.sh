#!/bin/sh

if ! type adlib 1>/dev/null 2>&1 ; then
  adlib(){
    local realname="$(readlink -f "$0")"
    local libdir="${realname%/*}/lib"
    while [ $# -gt 0 ] ; do
      local libname="${1%.sh}.sh"
      source "$libdir/$libname" || continue
      debug added "$libdir/$libname"
      shift
    done
  }
fi

adlib debug

is_array(){
  # check if passed array exists
  # TODO could also validate all elements exist
  debug "is_array $@"
  local a="${1:?Need array name}"
  local e # helper var listing array elements
  local s # array size
  eval e="\"\${${a}_E}\""
  eval s="\"\${${a}_S}\""
  if [ -n "${e}" ] && [ -n "${s}" ] ; then
    debug ${a} looks arrayish
    return 0
  fi
  debug ${a} is not an array
  false
}

array_get(){
  # store array element in given variable
  debug "array_get $@"
  local element="${1:?}"
  local var="${2:?}"
  eval ${var}="\"\$${element}\""
}

array_new(){
  debug "array_new $@"
  array_delete "${1}"
  array_push "${@}"
}

array_delete(){
  debug "array_delete $@"
  local a="${1:?Need array name}" # array name
  is_array ${a} || return
  # populate local vars
  local e # helper var listing array elements
  local s_var="${a}_S"
  local e_var="${a}_E"
  eval e="\"\${${e_var}}\""
  debug s_var: ${s_var}
  debug e_var: ${e_var}
  debug a: ${a}
  debug e: ${e}
  debug unset ${e} ${s_var} ${e_var}
  unset ${e} ${s_var} ${e_var}
}

array_dump(){
  debug "array_dump $@"
  local a="${1:?Need array name}" # array name
  is_array ${a} || return
  # populate local vars
  local e # helper var listing array elements
  local s_var="${a}_S"
  local e_var="${a}_E"
  eval e="\"\${${e_var}}\""
  debug s_var: ${s_var}
  debug e_var: ${e_var}
  debug a: ${a}
  debug e: ${e}
  for element in ${e} ; do
    debug eval echo "\"\$${element}\""
  done
  for element in ${e} ; do
    eval echo "\"\$${element}\""
  done
}

array_push(){
  debug "array_push $@"
  local a="${1:?Need array name}" # array name
  # TODO: be opinionated about 'a' content (validate)
  local s='' # array size
  local e='' # helper var listing array elements
  # populate local vars
  local s_var="${a}_S"
  local e_var="${a}_E"
  eval s="\"\${${s_var}:-0}\""
  eval e="\"\${${e_var}}\""
  debug s_var: ${s_var}
  debug e_var: ${e_var}
  shift # ditch array name, keep the rest
  debug a: ${a} s: ${s}
  # while will short circuit and ignore empty pushes
  while [ $# -gt 0 ] ; do
    : $((s++))
    debug eval ${a}_${s}="\"${1}\""
    eval ${a}_${s}="\"${1}\""
    e="${e:+${e} }${a}_${s}"
    shift
  done
  debug a: ${a} s: ${s}
  debug e: ${e}
  # push local vars back to array
  eval ${s_var}="\"${s}\""
  eval ${e_var}="\"${e}\""
}

