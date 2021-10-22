#!/usr/bin/awk -f
BEGIN {
  nil=""
  spc=" "
  nl="\n"
  cr="\r"
  ORS=nil
}
{
  cols=$1
  time=$2
  cmd=$3
  pingtime=$4
  adjcols=cols-5
  flag=nil
  defcol=nil
  a=sprintf("%%%ss",cols)
  spline=sprintf(cr a cr,spc)
  if (cmd == "r") {defcol=grn;flag="-";amax=0;max=0;total=0;i=0;avg=0;maxout_i=0i;dead_i=0;min=-1}
  i++
  if (pingtime=="dead") {
    dead_i++
    last=pingtime
    print spline red "dead",time,dead_i nc
    next
  }
  if (last=="dead") { printf nl }
  gsub(/[^[:digit:].]/,nil,pingtime)
  pingtime=int(pingtime)
  total+=pingtime
  avg=total/i
  maxmark=""

  if (pingtime>max) max=pingtime
  if (min<0||pingtime<min) min=pingtime
  if (pingtime>amax) {
    if (pingtime>maxout_val) {
      maxout_i++
      maxmark=">";amax=maxout_val
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
    bar=bar nc
  }
  bar=bar nl
  printf bar
  sbar=nil
  sbars=nil
  s=0
  sbar[s++]=sprintf("i:%d",i)
  sbar[s++]=sprintf("avg:%.1f",avg)
  sbar[s++]=sprintf("min:%d",min)
  sbar[s++]=sprintf("max:%d",max)
  sbar[s++]=sprintf("maxi:%d",maxout_i)
  sbar[s++]=sprintf("dead:%d",dead_i)
  sbar[s++]=sprintf("tot:%d",total)
  sbar[s++]=sprintf("col:%d",cols)
  sbar[s++]=sprintf("maxv:%d",maxout_val)
  for (s in sbar) {if (length(sbars sbar[s])+2<cols) {sbars=sbars "[" sbar[s] "]"} else {break}}
  printf sbars

  last=pingtime
}
# TODO
# [x] count whole width, drop marker on avg (need cols value). Drop marker on current and spaces for rest?
# [ ] build up the line in a var including value, time?, without colour then use the barcols value to sub(/^.{barcols}/,color"&"nc,line)
# [x] status bar, print with \r avg, monitored time, dropouts, max, min
