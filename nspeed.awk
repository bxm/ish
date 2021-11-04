#!/usr/bin/awk -f

function set_min(){
  if (min<0||ping<min) {
#    print "min",min,"ping",ping,nl
    min=ping}
}
function set_max(){
  maxmark=spc
  if (ping>max) max=ping
  if (ping>adj_max) {
    if (ping>maxout_val) {
      maxout_i++
      maxmark=">"
      adj_max=maxout_val
    } else {
      adj_max=int(ping*1.1)
    }
    # set flag, colour unless max changed from a reset
    if (flag==nil) flag="+"
    if (defcol==nil) defcol=red
  }
}

function sbar_add( str, var, seg){
  seg="[" sprintf(str,var) "]"
  if (length(sbar_str "" seg)<=cols) {
    sbar_str=sbar_str "" seg
  } else {return}
}
# TODO use sprintf padding to create avg mark, use
# difference of that and whole bar to create rest
# trim to width incase avg is out of range
# use sub to colour bar
# alt
# include values in the bar use diff colour for avg
function draw_pbar( _pbar_str) {
  ping_pc=ping/adj_max
  avg_pc=avg/adj_max
  avg_cols=int(avg_pc*adj_cols)
  ping_cols=int(ping_pc*adj_cols)

  if (defcol==nil) defcol=yel
  bar=cr
  # TODO build up str, colour once via rx
  bar=bar sprintf("%4s%1s",ping_i,flag)
  for(c=1;c<=adj_cols;c++) {
    if (c<=ping_cols) { bar=bar defcol ion }
    if (c==avg_cols) { bar=bar ":" nc ; continue }
    if (c==adj_cols) { bar=bar maxmark } else { bar=bar spc }
    bar=bar nc
  }
  printf bar nl
}

function draw_sbar() {
  sbar_str=nil
  sbar_add("%s",state)
  sbar_add("avg:%.1f",avg)
  sbar_add("min:%.1f",min)
  sbar_add("max:%.1f",max)
  sbar_add("maxi:%d",maxout_i)
  sbar_add("dead:%d",dead_i)
  sbar_add("tot:%d",total)
  sbar_add("i:%d",i)
  sbar_add("col:%d",cols)
  sbar_add("pingc:%d",ping_cols)
  sbar_add("avgc:%d",avg_cols)
  sbar_add("maxv:%d",maxout_val)
  # FIXME doesn't display outside of ish, think need to do the cursor positioning
  print sbar_str cr
}
function cline( _a){
  _a=sprintf("%%%ss",cols)
  printf(cr _a cr,spc)
}

function reset(type){
  defcol=grn
  if (type == "minmax" || type == nil) {
    max=0.0
    adj_max=0
    flag="m"
    min=-1.0
  }
  if (type == "avg" || type == nil) {
    flag="a"
    avg=0.0
    total=0.0
    i=0
  }
  if (type == nil) {
    ping_cols=0
    dead_i=0
    flag="-"
    maxout_i=0
    time_pc=0
  }
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
  ping=$4
  adj_cols=cols-5
  flag=nil
  defcol=nil
  state="up"
  if (cmd == "r") reset()
  if (cmd == "m") reset("minmax")
  if (cmd == "a") reset("avg")
  i++
  gsub(/[^-[:digit:].]/,nil,ping)
  ping=ping+0.0
  if (ping<0||ping>5000) {
    dead()
    next
  }
  if (last<0) { printf nl }
  ping_i=int(ping)
  total+=ping
  avg=total/(i-dead_i)

  set_min()
  set_max()

  draw_pbar()
  draw_sbar()
  last=ping
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

