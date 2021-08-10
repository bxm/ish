hex16(){
  h=0123456789abcdef
  echo $h | sed 's/./& /g'
}

hex256(){
  for A in $(hex16) ; do
    for B in $(hex16) ; do
      printf "%s '\x$A$B'" "$A$B"
      echo
    done
  done
}

main(){

  hex256

}

main "$@"
