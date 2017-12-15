#! /bin/bash

TIMESTAMP=`echo $(date +%Y%m%d-%H%M%S)`
DUMP=/var/tmp
OUTPUT=$DUMP/OUTPUT_$TIMESTAMP.txt
SVNROOT=/svnroot

for i in `ls $SVNROOT`; do
   echo $i
   svnadmin dump $SVNROOT/$i > $DUMP/`echo $i`_$TIMESTAMP 2>>$OUTPUT
done
