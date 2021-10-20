
#/pingtime=/ {
{
  time=$1
  cmd=$2
  pingtime=$3
  if (cmd == "r") {amax=0;max=0;total=0;i=0;avg=0;maxout_i=0i;dead_i=0}
  i++
  #print "cmd",cmd
  #print "pingtime",pingtime
  if (pingtime=="dead") {
    # TODO keep a count, update it
    dead_i++
    if (last=="dead") next
    last=pingtime
    printf "\r"
    print red "dead",time nc
    #      vvv blankline\r function?
    # TODO print line full of spaces to cover status
    #      allow status to stay, update when dead
    #      status as a function?  How to handle the \r though?
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
  if (pingtime>max) max=pingtime
  if (pingtime>amax) {
    if (pingtime>maxout) {
      maxout_i++
      maxmark=">";amax=maxout
    } else {
      amax=int(pingtime*1.15)
    }
    mflag="+"
    defcol=red
  } else {
    mflag=nil
  }
  pingtimepc=pingtime/amax
  avgpc=avg/amax
  posavg=int(avgpc*adjcols)
  barcols=int(pingtimepc*adjcols)
  #print pingtimepc
  #print avgpc
  #print barcols,posavg
  printf "\r"
  printf "%4s%1s",pingtime,mflag
  #for(c=0;c<barcols;c++) {printf "#"}
  for(c=1;c<=adjcols;c++) {
    if (c<=barcols) { printf defcol ion }
    if (c==posavg) { printf ":" nc ; continue }
    if (maxmark!="" && c==adjcols) { printf maxmark } else { printf spc }
    #if (maxmark=="") { printf spc } else { printf maxmark }
    printf nc
  }
  printf "\n"
  #printf "[cols:%d]",cols
  printf "[i:%d]",i
  printf "[total:%d]",total
  printf "[avg:%.1f]",avg
  printf "[max:%d]",max
  printf "[maxout:%d]",maxout
  printf "[maxout_i:%d]",maxout_i
  printf "[dead_i:%d]",dead_i

  last=pingtime
}
# TODO
# [x] count whole width, drop marker on avg (need cols value). Drop marker on current and spaces for rest?
# [ ] build up the line in a var including value, time?, without colour then use the barcols value to sub(/^.{barcols}/,color"&"nc,line)
# [ ] status bar, print with \r avg, monitored time, dropouts, max, min
