v="   FiBu";for i in $(seq 100);do(for m in $(seq 6 -1 2|grep -v [642]);do [ $((i%m)) = 0 ]&&g=${v:$m:2}zz$g;done;echo ${g-$i});done
