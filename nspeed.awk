BEGIN {
  adjcols=cols-5
  nil=""
  spc=" "
  nl="\n"
  cr="\r"
}
#/pingtime=/ {
{
  time=$1
  cmd=$2
  pingtime=$3
  flag=nil
  defcol=nil
  if (cmd == "r") {defcol=grn;flag="-";amax=0;max=0;total=0;i=0;avg=0;maxout_i=0i;dead_i=0}
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
  pingtime=int(pingtime)
  total+=pingtime
  avg=total/i
  #print pingtime,max
  maxmark=""
  if (pingtime>max) max=pingtime
  if (pingtime>amax) {
    if (pingtime>maxout) {
      maxout_i++
      maxmark=">";amax=maxout
    } else {
      amax=int(pingtime*1.15)
    }
    if (flag==nil) flag="+"
    if (defcol==nil) defcol=red
  }
  if (defcol==nil) defcol=yel
  pingtimepc=pingtime/amax
  avgpc=avg/amax
  posavg=int(avgpc*adjcols)
  barcols=int(pingtimepc*adjcols)

  bar=nil
  bar=bar cr
  bar=bar sprintf("%4s%1s",pingtime,flag)
  for(c=1;c<=adjcols;c++) {
    if (c<=barcols) { bar=bar defcol ion }
    if (c==posavg) { bar=bar ":" nc ; continue }
    if (maxmark!="" && c==adjcols) { bar=bar maxmark } else { bar=bar spc }
    ##if (maxmark=="") { printf spc } else { printf maxmark }
    bar=bar nc
  }
  bar=bar
  bar=bar nl
  printf bar
  sbar=nil
  #printf "[cols:%d]",cols
  sbar=sbar sprintf("[i:%d]",i)
  #printf "[total:%d]",total
  sbar=sbar sprintf("[avg:%.1f]",avg)
  sbar=sbar sprintf("[max:%d]",max)
  #printf "[maxout:%d]",maxout
  sbar=sbar sprintf("[maxout_i:%d]",maxout_i)
  sbar=sbar sprintf("[dead_i:%d]",dead_i)
  printf sbar

  last=pingtime
}
# TODO
# [x] count whole width, drop marker on avg (need cols value). Drop marker on current and spaces for rest?
# [ ] build up the line in a var including value, time?, without colour then use the barcols value to sub(/^.{barcols}/,color"&"nc,line)
# [ ] status bar, print with \r avg, monitored time, dropouts, max, min
