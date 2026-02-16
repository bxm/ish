#!/bin/sh

realname="$(readlink -f "${0}")"
realdir="${realname%/*}"
