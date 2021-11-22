#!/bin/sh
if [ -t 0 ]; then
    echo running interactivelly
else
    while read -r line ; do
        echo $line
    done
fi
