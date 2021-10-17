
/time=/ {
  i++
  time=$7
  fcols=cols-5
  gsub(/[^[:digit:].]/,"",time)
  time=int(time)
  total+=time
  avg=total/i
  #print time,max
  if (time>max) {
    max=time*1.0
    mflag="+"
  } else { mflag="" }
  timepc=time/max
  barcols=(timepc*(fcols))
  #print timepc
  printf "%4s%1s",time,mflag
  #for(c=0;c<barcols;c++) {printf "#"}
  for(c=0;c<fcols;c++) {
    if(c<barcols){printf red""ion" "nc}else{printf " "}
  }
  printf "\n"
}
# count whole width, drop marker on avg (need cols value). Drop marker on current and spaces for rest?
