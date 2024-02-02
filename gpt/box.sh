#!/bin/sh


draw_box() {
    topLeftX=$1
    topLeftY=$2
    bottomRightX=$3
    bottomRightY=$4

    # Move cursor to top-left corner
    echo -e "\e[${topLeftX};${topLeftY}H"

    for ((i = topLeftX; i <= bottomRightX; i++)); do
        for ((j = topLeftY; j <= bottomRightY; j++)); do
            if [ $i -eq $topLeftX ] || [ $i -eq $bottomRightX ]; then
                echo -n "-"
            elif [ $j -eq $topLeftY ] || [ $j -eq $bottomRightY ]; then
                echo -n "|"
            else
                echo -n " "
            fi
        done
        # Move cursor to the next line
        echo -e "\e[B"
        # Move cursor back to the starting column
        echo -e "\e[${topLeftX};${topLeftY}H"
    done
}

# Example usage: draw_box 2 2 8 4

main(){
  : "${4:?}"
  draw_box "$@"
}


main "$@"

