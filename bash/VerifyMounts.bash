#! /bin/bash

# ID: rb868x 4280 Dec 15 21:43 VerifyMounts.bash
# Tested on Solaris 10, Red Hat 5.3

clear

################################################
# VerifyMounts.bash check for mounted filesystems
# from a remote devices, e.g., 'nfs|samfs'.
# The program will also check for corrupted
# filesystems. Based on filters, the
# program will generate an output file with
# [CRITICAL WARNING INFO] 'ALARMS'.
################################################


# Delete output file prior to each run
MOUNTED=/tmp/Mounted-FS
rm $MOUNTED 2>/dev/null

FS_1=/tmp/FS_1
FS_2=/tmp/FS_2
DF_1=/tmp/DF_1

CRITICAL=false
CORRUPTED=false
FILESYSTEM_TYPE='nfs|samfs'

OS=`uname -s`

# LINUX
if [ `echo $OS |grep -i linux` ]; then
   FS=fstab
   DF='df -T'

   cat /etc/$FS | grep -v '^#' | egrep $FILESYSTEM_TYPE | awk '{ print $2 }' > $FS_1

   # Logic to detect filesystems that may be corrupted
   for i in `cat /etc/$FS | grep -v '^#' | egrep $FILESYSTEM_TYPE | awk '{ print $2 }'`; do
      ls "$i" 1>/dev/null 2>&1&
      ps -ef |grep $! |grep -v grep 1>/dev/null 2>&1
      if [ $? -eq 0 ]; then
         sleep 1
         kill -9 $! 1>/dev/null 2>&1
         if [ $? -eq 0 ]; then
            CORRUPTED=true
            CRITICAL=true
            echo -e "`date +%Y' '%m/%d' '%H:%M:%S` CRITICAL: $i may be mounted, but corrupted --- verify via \"ls $i\"\n" |tee -a $MOUNTED
         fi
      else
         echo -e "$i" >> $FS_2
      fi
   done

   if [ $CORRUPTED == false ]; then
      $DF | grep -v '^#' | egrep $FILESYSTEM_TYPE | awk '{ print $6 }' > $DF_1

      # Logic to detect filesystems that are not mounted
      if [[ -s $FS_2 ]]; then
         for i in `cat $FS_2`; do
            grep $i $DF_1 1>/dev/null
            if [ $? -ne 0 ]; then
               echo -e "`date +%Y' '%m/%d' '%H:%M:%S` CRITICAL: $i IS NOT MOUNTED \n" |tee -a $MOUNTED
               CRITICAL=true
            fi
         done
      fi
   else
      if [[ -s $FS_2 ]]; then
         for i in `cat $FS_2`; do
            #df -t `grep "$i" /etc/$FS |grep -v '^#' |awk -F' ' '{ print $2 }'` $i > $DF_1 
            #grep [0-9]% $DF_1
            df `grep "$i" /etc/$FS |grep -v '^#' |awk -F' ' '{ print $2 }'` 1>/dev/null 2>&1
            if [ $? -ne 0 ]; then
               echo -e "`date +%Y' '%m/%d' '%H:%M:%S` CRITICAL: $i IS NOT MOUNTED \n" |tee -a $MOUNTED
               CRITICAL=true
            fi
         done
      fi
   fi

# SOLARIS
else
   FS=vfstab
   DF='df -n'

   cat /etc/$FS | grep -v '^#' | egrep $FILESYSTEM_TYPE | awk '{ print $3 }' > $FS_1

   # Logic to detect filesystems that may be corrupted
   for i in `cat /etc/$FS | grep -v '^#' | egrep $FILESYSTEM_TYPE | awk '{ print $3 }'`; do
      ls "$i" 1>/dev/null 2>&1&
      ps -ef |grep $! |grep -v grep 1>/dev/null 2>&1
      if [ $? -eq 0 ]; then
         sleep 1
         kill -9 $! 1>/dev/null 2>&1
         if [ $? -eq 0 ]; then
            CORRUPTED=true
            CRITICAL=true
            echo -e "`date +%Y' '%m/%d' '%H:%M:%S` CRITICAL: $i may be mounted, but corrupted --- verify via \"ls $i\"\n" |tee -a $MOUNTED
         fi
      else
         echo -e "$i" >> $FS_2
      fi
   done

   if [ $CORRUPTED == false ]; then
      $DF | grep -v '^#' | egrep $FILESYSTEM_TYPE | awk '{ print $1 }' > $DF_1

      # Logic to detect filesystems that are not mounted
      if [[ -s $FS_2 ]]; then
         for i in `cat $FS_2`; do
            grep $i $DF_1 1>/dev/null
            if [ $? -ne 0 ]; then
               echo -e "`date +%Y' '%m/%d' '%H:%M:%S` CRITICAL: $i IS NOT MOUNTED \n" |tee -a $MOUNTED
               CRITICAL=true
            fi
         done
      fi
   else
      if [[ -s $FS_2 ]]; then
         for i in `cat $FS_2`; do
            df `grep "$i" /etc/$FS |grep -v '^#' |awk -F' ' '{ print $3 }'` 1>/dev/null 2>&1
            if [ $? -ne 0 ]; then
               echo -e "`date +%Y' '%m/%d' '%H:%M:%S` CRITICAL: $i IS NOT MOUNTED \n" |tee -a $MOUNTED
               CRITICAL=true
            fi
         done
      fi
   fi
fi

if [ $CRITICAL == true ]; then
   echo "There were erred filesystems that may not be mounted, corrupted, and/or defective mount points --- see '$MOUNTED'."
else
   echo "All filesystems are mounted"
fi

rm $FS_1 2>/dev/null
rm $FS_2 2>/dev/null
rm $DF_1 2>/dev/null
