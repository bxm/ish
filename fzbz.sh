for i in $(seq 1 100);do j=''
[ $((i%3)) = 0 ]&&j=Fizz
[ $((i%5)) = 0 ]&&j=${j}Buzz
echo ${j:-$i}
done

