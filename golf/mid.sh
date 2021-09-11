case $1 in 
  (1)
sed -r 's/ /   /;s/[^ ]+ (.+) [^ ]+/\1/;s/ +//'
  ;;
  (2)
sed -r 's/^[^ ]+//;s/ [^ ]+$//;s/^ //'
  ;;
  (*)
while read i;do
i=\ ${i#* };echo ${i% *}
done
esac

exit
Input: Samantha Vee Hills
Output: Vee

Input: Bob Dillinger
Output: (empty string or newline)

Input: John Jacob Jingleheimer Schmidt
Output: Jacob Jingleheimer

Input: Jose Mario Carasco-Williams
Output: Mario

Input: James Alfred Van Allen
Output: Alfred Van
