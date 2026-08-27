#!/usr/bin/awk -f
# Usage:
#   awk -v T0=100 -v half=10 -v hours=24 -f temp_decay.awk
# where:
#   T0    = starting temperature
#   half  = time for temperature to halve (same units as hours, e.g., hours)
#   hours = how many hours from now to evaluate

BEGIN {
    if (half <= 0) { print "half must be > 0" >"/dev/stderr"; exit 1 }
      t = hours / half
        T = T0 * (2 ^ (-t))
          # Print temperature (edit format as you like)
          printf "%.2f\n", T
      }

