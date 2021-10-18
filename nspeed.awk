
#/time=/ {
{
  # TODO need to special case if time=0.0
  i++
  time=$1
  #print "time",time
  if (time=="dead") {
    # TODO keep a count, update it
    if (last=="dead") next
    last=time
    print red "dead" nc
    next
  }
  gsub(/[^[:digit:].]/,nil,time)
  nil=""
  spc=" "
  adjcols=cols-5
  time=int(time)
  total+=time
  avg=total/i
  #print time,max
  if (time>max) {
    max=time*1.0
    mflag="+"
  } else { mflag=nil }
  # FIXME if time=0.0 this is a div0 error
  timepc=time/max
  avgpc=avg/max
  posavg=int(avgpc*adjcols)
  barcols=int(timepc*adjcols)
  #print timepc
  #print avgpc
  #print barcols,posavg
  printf "%4s%1s",time,mflag
  #for(c=0;c<barcols;c++) {printf "#"}
  for(c=0;c<adjcols;c++) {
    if (c<=barcols) { printf yel ion }
    if (c==posavg) { printf ":" } else { printf spc}
    #if ()
    printf nc
  }
  printf "\n"
  last=time
}
# count whole width, drop marker on avg (need cols value). Drop marker on current and spaces for rest?
