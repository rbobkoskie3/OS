#! /bin/bash

du -ah /mnt/ftpa/data/b000-all |grep "[0-9]G" | sort -n -r | head -n 10


# ID: rb868x 1352 Jul 18 18:56 VerifyFS-DiskSpace.bash

clear
DISK_SPACE=/tmp/Disk-Space-Utilization
rm $DISK_SPACE 2>/dev/null
TMP_1=/tmp/TMP_1
TMP_2=/tmp/TMP_2

ALL='(8[5-9]|9[0-9]|100)%'
INFO='(8[5-9])%'
WARNING='(9[0-5])%'
CRITICAL='(9[6-9]|100)%'


df -h | egrep $ALL > $TMP_1
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
   exit 1
fi

# echo -e "`date +%Y' '%m/%d' '%H:%M:%S` WARNING:"

# CRITICAL
egrep $CRITICAL $TMP_1 > $TMP_2
if [ -f $TMP_2 ]; then
   cat $TMP_2 | awk -F' ' '{ printf "%-10s %-10s %-40s %-40s\n", "CRITICAL:", $5, $1, $6 }' |tee -a $DISK_SPACE
fi

# WARNING
egrep $WARNING $TMP_1 > $TMP_2
if [ -f $TMP_2 ]; then
   cat $TMP_2 | awk -F' ' '{ printf "%-10s %-10s %-40s %-40s\n", "WARNING:", $5, $1, $6 }' |tee -a $DISK_SPACE
fi

# INFO
egrep $INFO $TMP_1 > $TMP_2
if [ -f $TMP_2 ]; then
   cat $TMP_2 | awk -F' ' '{ printf "%-10s %-10s %-40s %-40s\n", "INFO:", $5, $1, $6 }' |tee -a $DISK_SPACE
fi

rm $TMP_1 2>/dev/null
rm $TMP_2 2>/dev/null
