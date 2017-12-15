#!/bin/bash
#
# Script to generate random IP addresses of the form [1-233].[0-255].[0-255].[0-255]

function gen-ip() {

   declare -i RANGE=$1

   # check for RANGE
   if [ ! $RANGE -gt 0 ]; then
      # default to 255
      RANGE=255
   fi

   # echo $((`cat /dev/urandom|od -N2 -An` % 255))         #gives figure from 0 to 255
   RAND=$((`cat /dev/urandom|od -N2 -An` % $RANGE))
}

# returns first octet [1 - 223]
gen-ip 223
if [ $RAND -ne 0 ]; then
   echo -ne $RAND
fi

for i in 2 3 4; do gen-ip 255; echo -ne \.$RAND; done
echo
