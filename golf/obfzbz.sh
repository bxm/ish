v="gJeFiBu";for i in $(seq 100);do(for m in 6 10;do : $((m=m>>1));[ $((i%m)) = 0 ]&&g=$g${v:$m:2}zz;done;echo ${g-$i});done
