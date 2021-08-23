foo() {
for x in $s ; do
  $*
done
}

s="$(seq 1 30000)"

foo $*
