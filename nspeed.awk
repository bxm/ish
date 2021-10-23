#!/usr/bin/awk -f
function sbar_add( str, var){
  sbar[s++]="[" sprintf(str,var) "]"
  }
function draw_sbar( sbars) {
  sbar=nil
  sbars=nil
  s=0
  sbar_add("i:%d",i)
  sbar_add("avg:%.1f",avg)
  sbar_add("min:%d",min)
  sbar_add("max:%d",max)
  sbar_add("maxi:%d",maxout_i)
  sbar_add("dead:%d",dead_i)
  sbar_add("tot:%d",total)
  sbar_add("col:%d",cols)
  sbar_add("maxv:%d",maxout_val)
  for (s in sbar) {if (length(sbars sbar[s])<cols) {sbars=sbars sbar[s]} else {break}}
  print sbars
  }
function cline( _a){
  _a=sprintf("%%%ss",cols)
  printf(cr a cr,spc)
  }
BEGIN {
  barcols=0
  cr="\r"
  i=0
  max=0
  min=-1
  nil=""
  nl="\n"
  spc=" "
  timepc=0
  total=0
  hw="hello world"
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
  if (cmd == "r") {defcol=grn;flag="-";amax=0;max=0;total=0;i=0;avg=0;maxout_i=0i;dead_i=0;min=-1}
  i++
  if (pingtime=="dead") {
    dead_i++
    last=pingtime
    print cline() red "dead",time,dead_i nc
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
  draw_sbar()
  last=pingtime
}
# TODO
# [x] count whole width, drop marker on avg (need cols value). Drop marker on current and spaces for rest?
# [ ] build up the line in a var including value, time?, without colour then use the barcols value to sub(/^.{barcols}/,color"&"nc,line)
# [x] status bar, print with \r avg, monitored time, dropouts, max, min
