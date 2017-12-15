#! /bin/bash

# ID: rb868x 2783 Sep  1 21:01 VerifyTOP.bash

clear

TOPDIR=/tmp/TOP
rm $TOPDIR 2>/dev/null
TMP_1=/tmp/TMP_1
TMP_2=/tmp/TMP_2
TMP_LINUX=/tmp/LINUX

FILTER_PID='^((8[5-9]|9[0-9]|100)\.[0-9])|^100'
INFO='(8[5-9])\.[0-9]'
WARNING='(9[0-5])\.[0-9]'
CRITICAL='(9[6-9]|100)\.[0-9]|100'

OS=`uname -s`
if [ `echo $OS |grep -i linux` ]; then
   OS=linux
   top -bn 1 > $TMP_LINUX
   cat $TMP_LINUX | egrep '^[^a-zA-Z]' | awk -F' ' '{ printf "%-10s %-10s %-10s %-10s\n", $9, $10, $2, $1 }' | egrep $FILTER_PID > $TMP_1

   cat $TMP_LINUX | egrep '^[^a-zA-Z]' | awk -F' ' '{ if ($9 != $10) printf "%-10s %-10s %-10s %-10s\n", $10, $9, $2, $1 }' | egrep $FILTER_PID >> $TMP_1
else
   OS=solaris 
   top | egrep '^[^a-zA-Z]' | awk -F' ' '{ printf "%-10s %-10s %-10s\n", $10, $2, $1 }' | egrep $FILTER_PID > $TMP_1

fi


if [[ -s $TMP_1 ]]; then
   echo The following processes are using resources, output also saved in $TOPDIR
   if [ $OS == linux ]; then
      echo "ALARM CPU MEM USER PID" | awk '{ printf "%-10s %-10s %-10s %-10s %-10s\n\n", $1, $2, $3, $4, $5 }' |tee -a $TOPDIR
   else
      echo "ALARM CPU USERNAME PID" | awk '{ printf "%-10s %-10s %-10s %-10s\n\n", $1, $2, $3, $4 }' |tee -a $TOPDIR
   fi
else
   echo system processes are in check

   # Cleanup Files
   rm $TOPDIR 2>/dev/null
   rm $TMP_1 2>/dev/null
   rm $TMP_2 2>/dev/null
   rm $TMP_LINUX 2>/dev/null
   exit 1
fi

# echo -e "`date +%Y' '%m/%d' '%H:%M:%S` WARNING:"

# INFO 
if [ $OS == linux ]; then
   cat $TMP_1 | awk -F' ' '{ printf "%-10s %-10s %-10s %-10s %-10s\n", "INFO:", $1, $2, $3, $4 }' | egrep $INFO > $TMP_2
   if [[ -s $TMP_2 ]]; then
      cat $TMP_2 |tee -a $TOPDIR
   fi
else
   cat $TMP_1 | awk -F' ' '{ printf "%-10s %-10s %-10s %-10s\n", "INFO:", $1, $2, $3 }' | egrep $INFO > $TMP_2 
   if [[ -s $TMP_2 ]]; then
      cat $TMP_2 |tee -a $TOPDIR
   fi
fi

# WARNING
if [ $OS == linux ]; then
   cat $TMP_1 | awk -F' ' '{ printf "%-10s %-10s %-10s %-10s %-10s\n", "WARNING:", $1, $2, $3, $4 }' | egrep $WARNING > $TMP_2
   if [[ -s $TMP_2 ]]; then
      cat $TMP_2 |tee -a $TOPDIR
   fi
else
   cat $TMP_1 | awk -F' ' '{ printf "%-10s %-10s %-10s %-10s\n", "WARNING:", $1, $2, $3 }' | egrep $WARNING > $TMP_2
   if [[ -s $TMP_2 ]]; then
      cat $TMP_2 |tee -a $TOPDIR
   fi
fi

# CRITICAL 
if [ $OS == linux ]; then
   cat $TMP_1 | awk -F' ' '{ printf "%-10s %-10s %-10s %-10s %-10s\n", "CRITICAL:", $1, $2, $3, $4 }' | egrep $CRITICAL > $TMP_2
   if [[ -s $TMP_2 ]]; then
      cat $TMP_2 |tee -a $TOPDIR
   fi
else
   cat $TMP_1 | awk -F' ' '{ printf "%-10s %-10s %-10s %-10s\n", "CRITICAL:", $1, $2, $3 }' | egrep $CRITICAL > $TMP_2
   if [[ -s $TMP_2 ]]; then
      cat $TMP_2 |tee -a $TOPDIR
   fi
fi

rm $TMP_1 2>/dev/null
rm $TMP_2 2>/dev/null
rm $TMP_LINUX 2>/dev/null
