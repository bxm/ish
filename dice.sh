roll(){
  v=$((RANDOM % 6 + 1))
  set -- one two three four five six
  eval echo $v \$$v
}

main(){

roll 
roll 
roll 
roll 
roll 
roll 
}
main 
