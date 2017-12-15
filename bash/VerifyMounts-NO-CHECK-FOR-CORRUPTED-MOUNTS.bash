#! /bin/bash

# ID: rb868x 1025 Jul 19 19:54 VerifyMounts-NO-CHECK-FOR-CORRUPTED-MOUNTS.bash

clear
MOUNTED=/tmp/Mounted-FS
rm $MOUNTED 2>/dev/null
CRITICAL=false

OS=`uname -s`
if [ `echo $OS |grep -i linux` ]; then
      FS=fstab
      DF='df -T'
      $DF | grep -v '^#' | egrep 'nfs|samfs' | awk '{ print $6 }' > /tmp/df
      cat /etc/$FS | grep -v '^#' | egrep 'nfs|samfs' | awk '{ print $2 }' > /tmp/$FS
   else
      FS=vfstab
      DF='df -n'
      $DF | grep -v '^#' | egrep 'nfs|samfs' | awk '{ print $1 }' > /tmp/df
      cat /etc/$FS | grep -v '^#' | egrep 'nfs|samfs' | awk '{ print $3 }' > /tmp/$FS
fi

for i in `cat /tmp/$FS`; do
   grep $i /tmp/df 1>/dev/null
   if [ $? -ne 0 ]; then
      echo -e "`date +%Y' '%m/%d' '%H:%M:%S` CRITICAL: $i IS NOT MOUNTED \n" |tee -a $MOUNTED
      CRITICAL=true
   fi
done

if [ $CRITICAL == true ]; then
   echo "There were filesystems that were not mounted, see '$MOUNTED'."
else
   echo "All filesystems are mounted"
fi

rm /tmp/df 2>/dev/null
rm /tmp/$FS 2>/dev/null
