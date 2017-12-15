#! /bin/bash

while [ 1 ] ; do
    # Force some computation even if it is useless to actually work the CPU
    echo $((13**99)) 1>/dev/null 2>&1
done
