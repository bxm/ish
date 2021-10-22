#!/usr/bin/awk -f
BEGIN {
  nil=""
  spc=" "
  nl="\n"
  cr="\r"
}
#/pingtime=/ {
{
  cols=$1
  time=$2
  cmd=$3
  pingtime=$4
  adjcols=cols-5
  flag=nil
  defcol=nil
  a=sprintf("%%%ss",cols)
  spline=sprintf("\r" a "\r",spc)
  if (cmd == "r") {defcol=grn;flag="-";amax=0;max=0;total=0;i=0;avg=0;maxout_i=0i;dead_i=0;min=-1}
  i++
  #print "cmd",cmd
  #print "pingtime",pingtime
  if (pingtime=="dead") {
    # TODO keep a count, update it
    dead_i++
    if (last=="dead") next
    last=pingtime
    print spline red "dead",time nc
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
  if (min<0||pingtime<min) min=pingtime
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
  bar=bar nl
  printf bar
  sbar=nil
  sbars=nil
  s=0
  sbar[s++]=sprintf("[i:%d]",i)
  sbar[s++]=sprintf("[avg:%.1f]",avg)
  sbar[s++]=sprintf("[min:%d]",min)
  sbar[s++]=sprintf("[max:%d]",max)
  sbar[s++]=sprintf("[maxi:%d]",maxout_i)
  sbar[s++]=sprintf("[dead:%d]",dead_i)
  sbar[s++]=sprintf("[tot:%d]",total)
  sbar[s++]=sprintf("[col:%d]",cols)
  sbar[s++]=sprintf("[maxv:%d]",maxout)
  for (s in sbar) {if (length(sbars sbar[s])<cols) {sbars=sbars sbar[s]} else {break}}
  printf sbars

  last=pingtime
}
# TODO
# [x] count whole width, drop marker on avg (need cols value). Drop marker on current and spaces for rest?
# [ ] build up the line in a var including value, time?, without colour then use the barcols value to sub(/^.{barcols}/,color"&"nc,line)
# [ ] status bar, print with \r avg, monitored time, dropouts, max, min
