#!/bin/sh

sed -r 's/(.* )?([a-zA-Z]{3}[0-9]{4})( .*)?/\1\n/g' data


