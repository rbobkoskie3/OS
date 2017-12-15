#! /usr/bin/env bash

# ID: rb868x 1048 May 30 13:08 findOffshore_LinuxSolaris.bash
# Tested on Solaris 10, Red Hat 5.3

################################
if [[ $# != 1 ]]; then
   echo -e "\nUSAGE: ./findOffshore.bash [suits.dat|osuits.dat]\n"
   exit 0
fi
################################


################################
FILE=$1
OS=`uname -s`
ATTUID="^[a-zA-Z][a-zA-Z][0-9][0-9][0-9][a-zA-Z,0-9]$"
################################


################################
# LINUX
if [ `echo $OS |grep -i linux` ]; then
   EGREP="egrep -qi"

else
# SOLARIS
   EGREP="egrep -si"
fi
################################


if [[ $FILE == "suits.dat" ]]; then
   echo $FILE
   for i in `cut -d':' -f1 /etc/passwd`; do
      if echo $i | $EGREP $ATTUID; then
         COUNTRY=`grep $i $FILE |cut -d'|' -f14`
         if ! echo $COUNTRY |$EGREP USA; then
            echo $i $COUNTRY
         fi
      fi
   done
else
   echo $FILE
   for i in `cut -d':' -f1 /etc/passwd`; do
      if echo $i | $EGREP $ATTUID; then
         $EGREP $i $FILE
      fi
   done
fi
