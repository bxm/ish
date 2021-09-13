: $((i++))
j=$(printf %${i}s .)
sed "s/./${j//?/&}/g" $0
