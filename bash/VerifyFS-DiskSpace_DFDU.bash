#! /bin/bash

# ID: rb868x 2940 Aug  5 19:30 VerifyFS-DiskSpace.bash

# du -ah /var/* |grep "[0-9]G" | sort -n -r | head -n 5

clear
DISK_SPACE=/tmp/Disk-Space-Utilization
rm $DISK_SPACE 2>/dev/null
TMP_1=/tmp/TMP_1
TMP_2=/tmp/TMP_2
DF=/tmp/DF

ALL='(8[5-9]|9[0-9]|100)%'
INFO='(8[5-9])%'
WARNING='(9[0-5])%'
CRITICAL='(9[6-9]|100)%'

OS=`uname -s`

# LINUX
if [ `echo $OS |grep -i linux` ]; then
   FS=fstab

   # Logic to detect filesystems that may be corrupted
   for i in `cat /etc/$FS | grep -v '^#' | egrep 'nfs|samfs' | awk '{ print $2 }'`; do
      ls "$i" 1>/dev/null 2>&1&
      ps -ef |grep $! |grep -v grep 1>/dev/null 2>&1
      if [ $? -eq 0 ]; then
         sleep 1
         kill -9 $! 1>/dev/null 2>&1
         if [ $? -eq 0 ]; then
            echo -e "`date +%Y' '%m/%d' '%H:%M:%S` CRITICAL: $i may be mounted, but corrupted --- verify via \"ls $i\"\n" |tee -a $DISK_SPACE
            echo -e "Alarms saved to '$DISK_SPACE'"
            echo -e "Fix corrupted FS ... Exiting script"
            exit 1
         fi
      else
         df -h -P | tr -s " "| grep -v File | tr " " "|" > $DF
      fi
   done

# SOLARIS
else

   FS=vfstab
   # Logic to detect filesystems that may be corrupted
   for i in `cat /etc/$FS | grep -v '^#' | egrep 'nfs|samfs' | awk '{ print $3 }'`; do
      ls "$i" 1>/dev/null 2>&1&
      ps -ef |grep $! |grep -v grep 1>/dev/null 2>&1
      if [ $? -eq 0 ]; then
         sleep 1
         kill -9 $! 1>/dev/null 2>&1
         if [ $? -eq 0 ]; then
            echo -e "`date +%Y' '%m/%d' '%H:%M:%S` CRITICAL: $i may be mounted, but corrupted --- verify via \"ls $i\"\n" |tee -a $DISK_SPACE
            echo -e "Alarms saved to '$DISK_SPACE'"
            echo -e "Fix corrupted FS ... Exiting script"
            exit 1
         fi
      else
         df -h | tr -s " "| grep -v File | tr " " "|" > $DF
      fi
   done
fi


cat $DF | egrep $ALL > $TMP_1
grep '.*' $TMP_1 1>/dev/null 2>&1
if [ $? -eq 0 ]; then
   echo The following filesystems are near maximum capacitiy, output also saved in $DISK_SPACE
   echo "ALARM CAPACITY FILESYSTEM MOUNTED-ON" | awk '{ printf "%-10s %-10s %-40s %-40s\n\n", $1, $2, $3, $4 }' |tee -a $DISK_SPACE
else
   echo Filesystems are OK

   # Cleanup Files
   rm $DISK_SPACE 2>/dev/null
   rm $TMP_1 2>/dev/null
   rm $TMP_2 2>/dev/null
   rm $DF 2>/dev/null
   exit 2
fi

# echo -e "`date +%Y' '%m/%d' '%H:%M:%S` WARNING:"

# CRITICAL
egrep $CRITICAL $TMP_1 > $TMP_2
if [ -f $TMP_2 ]; then
   cat $TMP_2 | awk -F'|' '{ printf "%-10s %-10s %-40s %-40s\n", "CRITICAL:", $5, $1, $6 }' |tee -a $DISK_SPACE
fi

# WARNING
egrep $WARNING $TMP_1 > $TMP_2
if [ -f $TMP_2 ]; then
   cat $TMP_2 | awk -F'|' '{ printf "%-10s %-10s %-40s %-40s\n", "WARNING:", $5, $1, $6 }' |tee -a $DISK_SPACE
fi

# INFO
egrep $INFO $TMP_1 > $TMP_2
if [ -f $TMP_2 ]; then
   cat $TMP_2 | awk -F'|' '{ printf "%-10s %-10s %-40s %-40s\n", "INFO:", $5, $1, $6 }' |tee -a $DISK_SPACE
fi

rm $TMP_1 2>/dev/null
rm $TMP_2 2>/dev/null
rm $DF 2>/dev/null