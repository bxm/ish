#for i in $(seq 100);do([ $((i%5)) = 0 ]&&j=Buzz;[ $((i%3)) = 0 ]&&j=Fizz$j;echo ${j-$i});done
f(){ [ $((i%$1)) = 0 ]&&j=$2zz$j;};for i in `seq 100`;do(f 5 Bu;f 3 Fi;echo ${j-$i});done
