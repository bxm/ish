v="gJeFiBu";for i in $(seq 100);do(for m in $(seq 6|grep -v [6421]);do [ $((i%m)) = 0 ]&&g=$g${v:$m:2}zz;done;echo ${g-$i});done
