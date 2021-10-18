
#/pingtime=/ {
{
  # TODO need to special case if pingtime=0.0
  i++
  time=$1
  pingtime=$2
  #print "pingtime",pingtime
  if (pingtime=="dead") {
    # TODO keep a count, update it
    if (last=="dead") next
    last=pingtime
    print red "dead",time nc
    next
  }
  gsub(/[^[:digit:].]/,nil,pingtime)
  nil=""
  spc=" "
  adjcols=cols-5
  pingtime=int(pingtime)
  total+=pingtime
  avg=total/i
  #print pingtime,max
  if (pingtime>max) {
    max=pingtime*1.0
    mflag="+"
  } else { mflag=nil }
  # FIXME if pingtime=0.0 this is a div0 error
  pingtimepc=pingtime/max
  avgpc=avg/max
  posavg=int(avgpc*adjcols)
  barcols=int(pingtimepc*adjcols)
  #print pingtimepc
  #print avgpc
  #print barcols,posavg
  printf "%4s%s%1s%s",pingtime,red,mflag,nc
  #for(c=0;c<barcols;c++) {printf "#"}
  for(c=0;c<adjcols;c++) {
    if (c<=barcols) { printf yel ion }
    if (c==posavg) { printf ":" } else { printf spc}
    #if ()
    printf nc
  }
  printf "\n"
  last=pingtime
}
# count whole width, drop marker on avg (need cols value). Drop marker on current and spaces for rest?
