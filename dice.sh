rand(){
  strings /dev/random|grep -Eo "[1-6]" | head -1
}

roll(){
  #i=$((RANDOM % 6 + 1))
  i=$(rand)
  set -- \
    .../.o./... \
    o../.../..o \
    o../.o./..o \
    o.o/.../o.o \
    o.o/.o./o.o \
    o.o/o.o/o.o

  eval r="\$$i"
  r="${r//\// }"
  printf "%s\n%s\n%s\n\n" $r | sed 's/[.]/ /g'
}

basic(){
  v=$((RANDOM % 6 + 1))
  set -- one two three four five six
  eval echo $v \$$v
}

main(){

roll 
}
main 
