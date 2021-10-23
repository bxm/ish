#!/usr/bin/awk -f
function sbar_add( str, var){
  sbar[s++]="[" sprintf(str,var) "]"
  }
function draw_sbar( _sbar_str) {
  sbar=nil
  _sbar_str=nil
  s=0
  sbar_add("i:%d",i)
  sbar_add("avg:%.1f",avg)
  sbar_add("min:%.1f",min)
  sbar_add("max:%.1f",max)
  sbar_add("maxi:%d",maxout_i)
  sbar_add("dead:%d",dead_i)
  sbar_add("tot:%d",total)
  sbar_add("col:%d",cols)
  sbar_add("maxv:%d",maxout_val)
  for (s in sbar) {if (length(_sbar_str sbar[s])<=cols) {_sbar_str=_sbar_str sbar[s]} else {break}}
  print _sbar_str cr
  }
function cline( _a){
  _a=sprintf("%%%ss",cols)
  printf(cr a cr,spc)
  }

function reset(){
  amax=0
  avg=0
  barcols=0
  dead_i=0
  defcol=grn
  flag="-"
  i=0
  max=0
  maxout_i=0i
  min=-1
  timepc=0
  total=0
  }

BEGIN {
  cr="\r"
  nil=""
  nl="\n"
  spc=" "
  hw="hello world"
  ORS=nil
  reset()
}
{
  cols=$1
  time=$2
  cmd=$3
  pingtime=$4
  adjcols=cols-5
  flag=nil
  defcol=nil
  if (cmd == "r") reset()
  i++
  if (pingtime=="dead") {
    dead_i++
    last=pingtime
    print cline() red "dead",time,dead_i nc
    next
  }
  if (last=="dead") { printf nl }
  gsub(/[^[:digit:].]/,nil,pingtime)
  ipingtime=int(pingtime)
  total+=pingtime
  avg=total/i
  maxmark=""

  if (ipingtime>max) max=ipingtime
  if (min<0||ipingtime<min) min=ipingtime
  if (ipingtime>amax) {
    if (ipingtime>maxout_val) {
      maxout_i++
      maxmark=">";amax=maxout_val
    } else {
      amax=int(pingtime*1.1)
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
  # TODO
  bar=bar sprintf("%4s%1s",ipingtime,flag)
  for(c=1;c<=adjcols;c++) {
    if (c<=barcols) { bar=bar defcol ion }
    if (c==posavg) { bar=bar ":" nc ; continue }
    if (maxmark!="" && c==adjcols) { bar=bar maxmark } else { bar=bar spc }
    bar=bar nc
  }
  printf bar nl
  draw_sbar()
  last=pingtime
}

# TODO
# [x] count whole width, drop marker on avg (need cols value). Drop marker on current and spaces for rest?
# [x] status bar, print with \r avg, monitored time, dropouts, max, min
# [ ] build up the line in a var including value, time?, without colour then use the barcols value to sub(/^.{barcols}/,color"&"nc,line)
# [ ] sort out floats and display values
# [ ] draw mark for min value
# [ ] replace dead with status bar
# [ ] colour bar, dead different colour


