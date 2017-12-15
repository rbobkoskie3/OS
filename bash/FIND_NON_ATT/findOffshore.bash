#! /usr/bin/env bash

# ID: rb868x 1268 Apr 25 12:49 findOffshore.bash
# Tested on Red Hat 5.3, Solaris 10


# ========================================
if [[ $# != 1 ]]; then
   echo -e "\nUSAGE: ./findOffshore.bash [suits.dat|osuits.dat]\n"
   exit 0
fi
FILE=$1

ATTUID="[a-zA-Z][a-zA-Z][0-9][0-9][0-9][a-zA-Z0-9]"

OS=`uname -s`
if [ `echo $OS |grep -i linux` ]; then
   EGREP="egrep -q"
   # REGEX ONLY WORKS FOR LINUX: ATTUID="[a-zA-Z]{2}[0-9]{3}[a-zA-Z0-9]"
else # Solaris
   EGREP="egrep -s"
fi
# ========================================



if [[ $FILE == "suits.dat" ]]; then
   echo $FILE
   for i in `getent passwd |cut -d':' -f1`; do
      # LINUX ONLY, PROGRAM WILL NOT RUN IN SOLARIS
      # IF THIS LINE IS NOT COMMENTED OUT:
      # if [[ $i =~ $ATTUID ]]; then
      if echo $i | $EGREP $ATTUID; then
         COUNTRY=`grep $i $FILE |cut -d'|' -f14`
         if ! echo $COUNTRY | $EGREP USA; then
            echo $i $COUNTRY
         fi
      fi
   done

else
   echo $FILE
   for i in `getent passwd |cut -d':' -f1`; do
      # LINUX ONLY, PROGRAM WILL NOT RUN IN SOLARIS
      # IF THIS LINE IS NOT COMMENTED OUT:
      # if [[ $i =~ $ATTUID ]]; then
      if echo $i | $EGREP $ATTUID; then
         egrep $i $FILE |cut -d'|' -f1
      fi
   done
fi
