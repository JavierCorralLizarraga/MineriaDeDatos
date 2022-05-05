#!/bin/bash
touch metadata.R
echo 'autos_colnames <- c(' > metadata.R
sed -n 61,89p imports-85.names | cut -f 2 -d "." | cut -f 1 -d ":" | sed "4,6d" | sed 's/^.//' | awk '{ printf "'\''%s'\','\n", $0 }' | xargs -n26 -d'\n' | sed 's/.$//' >> metadata.R
echo ')' >> metadata.R
