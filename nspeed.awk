#!/usr/bin/awk -f

function set_min(){
  if (min<0||pingtime<min) {
#    print "min",min,"ping",pingtime,nl
    min=pingtime}
}
function set_max(){
  maxmark=spc
  if (pingtime>max) max=pingtime
  if (pingtime>adj_max) {
    if (pingtime>maxout_val) {
      maxout_i++
      maxmark=">"
      adj_max=maxout_val
    } else {
      adj_max=int(pingtime*1.1)
    }
    # set flag, colour unless max changed from a reset
    if (flag==nil) flag="+"
    if (defcol==nil) defcol=red
  }
}

function sbar_add( str, var){
  sbar[s++]="[" sprintf(str,var) "]"
}

function draw_pbar( _pbar_str) {
  pingtime_pc=pingtime/adj_max
  avg_pc=avg/adj_max
  posavg=int(avg_pc*adj_cols)
  ping_cols=int(pingtime_pc*adj_cols)

  if (defcol==nil) defcol=yel
  bar=cr
  # TODO build up str, colour once via rx
  bar=bar sprintf("%4s%1s",ipingtime,flag)
  for(c=1;c<=adj_cols;c++) {
    if (c<=ping_cols) { bar=bar defcol ion }
    if (c==posavg) { bar=bar ":" nc ; continue }
    if (c==adj_cols) { bar=bar maxmark } else { bar=bar spc }
    bar=bar nc
  }
  printf bar nl
}

function draw_sbar( _sbar_str) {
  s=0 # so we always overwrite the array
  _sbar_str=nil
  sbar_add("%s",state)
  sbar_add("avg:%.1f",avg)
  sbar_add("min:%.1f",min)
  sbar_add("max:%.1f",max)
  sbar_add("maxi:%d",maxout_i)
  sbar_add("dead:%d",dead_i)
  sbar_add("tot:%d",total)
  sbar_add("col:%d",cols)
  sbar_add("maxv:%d",maxout_val)
  sbar_add("i:%d",i)
  for (s in sbar) {
    if (length(_sbar_str sbar[s])<=cols) {
      _sbar_str=_sbar_str "" sbar[s]
    } else {break}
  }
  # FIXME doesn't display outside of ish, think need to do the cursor positioning
  print _sbar_str cr
}
function cline( _a){
  _a=sprintf("%%%ss",cols)
  printf(cr _a cr,spc)
}

function reset(){
  adj_max=0
  avg=0.0
  ping_cols=0
  dead_i=0
  defcol=grn
  flag="-"
  i=0
  max=0.0
  maxout_i=0
  min=-1.0
  time_pc=0
  total=0.0
  }

function dead(){
  state="dead"
  dead_i++
  last=-1
  cline()
  print red "dead",time,dead_i nc
  }

function rint( _float){
  return sprintf("%.f", _float)
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
  adj_cols=cols-5
  flag=nil
  defcol=nil
  state="up"
  if (cmd == "r") reset()
  i++
  gsub(/[^-[:digit:].]/,nil,pingtime)
  pingtime=pingtime+0.0
  if (pingtime<0||pingtime>5000) {
    dead()
    next
  }
  if (last<0) { printf nl }
  ipingtime=int(pingtime)
  total+=pingtime
  avg=total/(i-dead_i)

  set_min()
  set_max()

  draw_pbar()
  draw_sbar()
  last=pingtime
}

# TODO
# [x] count whole width, drop marker on avg (need cols value). Drop marker on current and spaces for rest?
# [x] status bar, print with \r avg, monitored time, dropouts, max, min
# [ ] build up the line in a var including value, time?, without colour then use the ping_cols value to sub(/^.{ping_cols}/,color"&"nc,line)
# [x] sort out floats and display values
# [ ] draw mark for min value
# [ ] replace dead with status bar
# [ ] colour bar, dead different colour
# [x] FIXME maxout draws wrong after dead
# [x] FIXME avg includes dead???
# [x] FIXME min getting set wrong 
# [ ] TODO clear screen, pbar steps down, sbar at foot

