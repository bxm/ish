#!/bin/sh

adlib(){
  local realname="$(readlink -f "${0}")"
  local libdir="${realname%/*}/lib"
  while [ $# -gt 0 ] ; do
    local libname="${1%.sh}.sh"
    source "${libdir}/${libname}" || continue
    debug added "${libdir}/${libname}"
    shift
  done
}

colour(){
awk '{
    if ($1 < 0) {
              color = 31;  # Red
                  } else if ($1 > 100) {
                          color = 32;  # Green
                              } else {
                                      color = 31 + int($1);
                                          }
                                            
                                            printf "\033[38;5;%dm\033[40m%.2f%%\033[0m\n", color, $1;
                                          }' 

}

co(){
awk 'BEGIN {
    min = -100;   # Minimum percentage value
    max = 100;    # Maximum percentage value
    steps = 100;  # Number of color steps
    range = max - min;
}

{
    percent = $1;
    
    # Calculate the color value
    color_value = int((percent - min) / range * steps);
    
    # Ensure it stays within bounds
    color_value = (color_value < 0) ? 0 : (color_value > steps) ? steps : color_value;
    
    # Calculate the R, G, B values
    red = int(255 * (1 - color_value / steps));
    green = int(255 * (color_value / steps));
    
    # Print in the desired color
    printf "\033[48;2;%d;%d;0m\033[38;2;255;255;255m%.2f%%\033[0m\n", red, green, percent;
}'

}
c(){
awk 'BEGIN {
    min = -100;   # Minimum percentage value
    max = 100;    # Maximum percentage value
    steps = 100;  # Number of color steps
    range = max - min;
}

{
    percent = $1;

    # Calculate the color value
    color_value = int((percent - min) / range * steps);

    # Ensure it stays within bounds
    color_value = (color_value < 0) ? 0 : (color_value > steps) ? steps : color_value;

    # Calculate the R, G, B values
    red = int(255 * (1 - color_value / steps));
    green = int(255 * (color_value / steps));

    # Print in the desired color
    printf "\033[38;2;%d;%d;0m\033[40m%.2f%%\033[0m\n", red, green, percent;
}'
}

main(){
  debug -f main "$@"
  for x in $(seq 105 -5 0) ; do
    echo -$x | c
  done
  for x in $(seq 0 5 105) ; do
    echo $x | c
  done
}

adlib debug install

main "$@"

