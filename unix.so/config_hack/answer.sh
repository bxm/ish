#!/bin/sh
#!/bin/bash

conf="/home/fabian/.config/i3/config"
conf="./config"

case "${1}" in
  (alt) key=Mod1 ;;
  (win) key=Mod4 ;;
  (*)   printf "Invalid key: %s\n" "${1}" ; exit 1 ;;
esac

sed -i.backup 's/^\(set $mod\) .*/\1 '"${key}/" "${conf}" || exit

printf "Changed successfully to %s/%s\n" "${1}" "${key}"
