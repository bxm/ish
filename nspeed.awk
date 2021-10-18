
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
  defcol=yel
  maxmark=""
  if (pingtime>max) {
    if (pingtime>maxout) {
      maxmark=">";max=maxout
    } else {
      max=int(pingtime*1.15)
    }
    mflag="+"
    defcol=red
  } else {
    mflag=nil
  }
  pingtimepc=pingtime/max
  avgpc=avg/max
  posavg=int(avgpc*adjcols)
  barcols=int(pingtimepc*adjcols)
  #print pingtimepc
  #print avgpc
  #print barcols,posavg
  printf "%4s%1s",pingtime,mflag
  #for(c=0;c<barcols;c++) {printf "#"}
  # TODO build up the line in a var including value, time?, without colour
  #      then use the barcols value to sub(/^.{barcols}/,color"&"nc,line)
  for(c=1;c<=adjcols;c++) {
    if (c<=barcols) { printf defcol ion }
    if (c==posavg) { printf ":" nc ; continue }
    # FIXME bug displays > across whole line
    if (maxmark!="" && c==adjcols) { printf maxmark } else { printf spc }
    #if (maxmark=="") { printf spc } else { printf maxmark }
    printf nc
  }
  printf "\n"
  last=pingtime
}
# count whole width, drop marker on avg (need cols value). Drop marker on current and spaces for rest?
