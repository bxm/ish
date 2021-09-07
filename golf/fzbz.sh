for i in $(seq 1 100);do([ $((i%5)) = 0 ]&&j=Buzz;[ $((i%3)) = 0 ]&&j=Fizz$j;echo ${j-$i});done
