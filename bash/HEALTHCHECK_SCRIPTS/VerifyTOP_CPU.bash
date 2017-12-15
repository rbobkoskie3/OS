#! /bin/bash

# ID: rb868x 9260 Dec 15 20:44 VerifyTOP_CPU.bash
# Tested on Solaris 10, Red Hat 5.3

clear

################################################
# VerifyTOP_CPU.bash monitors CPU
# utilization, as well as tasks currently being
# managed by the kernel. Based on filters, the
# program will generate an output file with
# [CRITICAL WARNING INFO] 'ALARMS'.
################################################


# Delete output file prior to each run
TOPDIR=/tmp/TOP
rm $TOPDIR 2>/dev/null

TMP_1=/tmp/TMP_1
TMP_2=/tmp/TMP_2
TMP_11=/tmp/TMP_11
TMP_22=/tmp/TMP_22
TMP_12=/tmp/TMP_12
TMP_LINUX=/tmp/LINUX
TMP_SOLARIS=/tmp/SOLARIS
PIDS=/tmp/PIDS


# FILTER_ALL* set to capture any process running between 85 < PID < 199
# FILTER_ALL_TSK user to filter the list of tasks currently being managed by the kernel
# FILTER_ALL_SUM used to filter the system summary information
# INFO_*, WARNING_*, CRITICAL_* are used for assigning priority to:
#                               *TSK --- the list of tasks currently being managed by the kernel
#                               *SUM --- the system summary information in TOP table

INFO_TSK='8[5-9].*\%'
WARNING_TSK='9[0-5].*\%'
CRITICAL_TSK='9[6-9].*\%|1[0-9][0-9].*\%'
FILTER_ALL_TSK="^($INFO_TSK|$WARNING_TSK|$CRITICAL_TSK)"

INFO_SUM='8[5-9]'
WARNING_SUM='9[0-5]'
CRITICAL_SUM='9[6-9]|1[0-9][0-9]'
FILTER_ALL_SUM="($INFO_SUM|$WARNING_SUM|$CRITICAL_SUM)\..*\%"

BOOL_CRIT=false
BOOL_WARN=false

OS=`uname -s`

###############
# OS == LINUX
if [ `echo $OS |grep -i linux` ]; then
   OS=linux
   top -bn 1 > $TMP_LINUX
###############

   # Filter the list of tasks currently being managed by the kernel, looking for %CPU
   # Append "%" to both the CPU and MEM variables. This is needed to eliminate other numbers that may
   # fall in the range 85 < PID < 199 (e.g., PID), and thus be counted as an alarm. Note that appending "%"
   # only apples for Linux, as Solaris uses a "%" in the list of tasks
   cat $TMP_LINUX | egrep '^[^a-zA-Z]' | awk -F' ' '{ printf "%-10s %-10s %-10s %-10s %-10s\n", $9"%", $10"%", $2, $1, $12 }' | egrep $FILTER_ALL_TSK > $TMP_1

   # Eliminate duplicate PIDS, e.g., for LINUX, both %CPU %MEM are counted. However, %CPU %MEM should only be counted once
   # Copy PIDS to file to use for regex match
   cat $TMP_1 | awk -F' ' '{ print $4 }' > $PIDS

   # Filter the list of tasks currently being managed by the kernel, looking for %MEM
   # Append "%" to both the CPU and MEM variables
   cat $TMP_LINUX | egrep '^[^a-zA-Z]' | awk -F' ' '{ if ($9 != $10) printf "%-10s %-10s %-10s %-10s %-10s\n", $10"%", $9"%", $2, $1, $12 }' | egrep $FILTER_ALL_TSK | awk -F' ' '{ printf "%-10s %-10s %-10s %-10s %-10s\n", $2, $1, $3, $4, $5 }' >> $TMP_12

   # Eliminate any duplicate PIDS from $TMP_12
   for i in `cat $PIDS`; do
      sed -i -e '/[a-zA-Z] .* '"`echo $i`"' .*$/d' $TMP_12
   done

   # Merge files, no duplicate PIDS
   cat $TMP_12 >> $TMP_1

   # Filter the system summary information
   cat $TMP_LINUX | egrep '^[a-zA-Z]' | awk -F',' '{ printf "%-10s %-10s %-10s %-10s %-10s %-10s %-10s\n", $1, $2, $3, $5, $6, $7, $8 }' | egrep $FILTER_ALL_SUM > $TMP_11

###############
# OS == SOLARIS
else
   OS=solaris
   top > $TMP_SOLARIS
###############

   # Filter the list of tasks currently being managed by the kernel
   cat $TMP_SOLARIS | egrep '^[^a-zA-Z]' | awk -F' ' '{ printf "%-10s %-10s %-10s %-10s\n", $10, $2, $1, $11 }' | egrep $FILTER_ALL_TSK > $TMP_1

   # Filter the system summary information
   cat $TMP_SOLARIS | egrep '^[a-zA-Z]' | awk -F',' '{ printf "%-10s %-10s %-10s %-10s\n", $2, $3, $4, $5 }' | egrep $FILTER_ALL_SUM > $TMP_11
fi


#####################################
# Logic for assigning priority to the system summary information in TOP table
#####################################

if [[ -s $TMP_11 ]]; then
   echo CPU utilization is above thresholds, output also saved in $TOPDIR

   ###############
   # OS == LINUX
   ###############
   if [ $OS == linux ]; then
      echo -e "\nALARM USER SYS NICE WA HI SI ST" | awk '{ printf "%-10s %-10s %-10s %-10s %-10s %-10s %-10s %-10s\n\n", $1, $2, $3, $4, $5, $6, $7, $8 }' |tee -a $TOPDIR

      # CRITICAL
      cat $TMP_11 | awk -F' ' '{ printf "%-10s %-10s %-10s %-10s %-10s %-10s %-10s %-10s\n", "CRITICAL:", $2, $3, $4, $5, $6, $7, $8 }' | egrep $CRITICAL_SUM > $TMP_22
      if [[ -s $TMP_22 ]]; then
         cat $TMP_22 |tee -a $TOPDIR
         BOOL_CRIT=true
      fi

      # WARNING
      if [ $BOOL_CRIT == false ]; then
         cat $TMP_11 | awk -F' ' '{ printf "%-10s %-10s %-10s %-10s %-10s %-10s %-10s %-10s\n", "WARNING:", $2, $3, $4, $5, $6, $7, $8 }' | egrep $WARNING_SUM > $TMP_22
         if [[ -s $TMP_22 ]]; then
            cat $TMP_22 |tee -a $TOPDIR
            BOOL_WARN=true
         fi
      fi

      # INFO
      if [[ $BOOL_CRIT == false && $BOOL_WARN == false ]]; then
         cat $TMP_11 | awk -F' ' '{ printf "%-10s %-10s %-10s %-10s %-10s %-10s %-10s %-10s\n", "INFO:", $2, $3, $4, $5, $6, $7i, $8 }' | egrep $INFO_SUM > $TMP_22
         if [[ -s $TMP_22 ]]; then
            cat $TMP_22 |tee -a $TOPDIR
         fi
      fi

   ###############
   # OS == SOLARIS
   ###############
   else
      echo -e "\nALARM USER KERNAL IOWAIT SWAP" | awk '{ printf "%-10s %-10s %-10s %-10s %-10s\n\n", $1, $2, $3, $4, $5 }' |tee -a $TOPDIR

      # CRITICAL
      cat $TMP_11 | awk -F' ' '{ printf "%-10s %-10s %-10s %-10s %-10s\n", "CRITICAL:", $1, $3, $5, $7 }' | egrep $CRITICAL_SUM > $TMP_22
      if [[ -s $TMP_22 ]]; then
         cat $TMP_22 |tee -a $TOPDIR
         BOOL_CRIT=true
      fi

      # WARNING
      if [ $BOOL_CRIT == false ]; then
         cat $TMP_11 | awk -F' ' '{ printf "%-10s %-10s %-10s %-10s %-10s\n", "WARNING:", $1, $3, $5, $7 }' | egrep $WARNING_SUM > $TMP_22
         if [[ -s $TMP_22 ]]; then
            cat $TMP_22 |tee -a $TOPDIR
            BOOL_WARN=true
         fi
      fi

      # INFO
      if [[ $BOOL_CRIT == false && $BOOL_WARN == false ]]; then
         cat $TMP_11 | awk -F' ' '{ printf "%-10s %-10s %-10s %-10s %-10s\n", "INFO:", $1, $3, $5, $7 }' | egrep $INFO_SUM > $TMP_22
         if [[ -s $TMP_22 ]]; then
            cat $TMP_22 |tee -a $TOPDIR
         fi
      fi
   fi

else
   echo CPU utilization in check
fi


#####################################
# Logic for assigning priority to the list of tasks currently being managed by the kernel
#####################################

if [[ -s $TMP_1 ]]; then
   echo The following processes are using resources, output also saved in $TOPDIR

   ###############
   # OS == LINUX
   ###############
   if [ $OS == linux ]; then
      echo -e "\nALARM CPU MEM USER PID COMMAND" | awk '{ printf "%-10s %-10s %-10s %-10s %-10s %-10s\n\n", $1, $2, $3, $4, $5, $6 }' |tee -a $TOPDIR

      # CRITICAL
      cat $TMP_1 | awk -F' ' '{ printf "%-10s %-10s %-10s %-10s %-10s %-10s\n", "CRITICAL:", $1, $2, $3, $4, $5 }' | egrep $CRITICAL_TSK > $TMP_2
      if [[ -s $TMP_2 ]]; then
         cat $TMP_2 |tee -a $TOPDIR
         # Copy CRITICAL PIDS to file to use for regex match '>' overwrite $PIDS
         cat $TMP_2 | awk -F' ' '{ print $5 }' > $PIDS
      fi

      # WARNING
      cat $TMP_1 | awk -F' ' '{ printf "%-10s %-10s %-10s %-10s %-10s %-10s\n", "WARNING:", $1, $2, $3, $4, $5 }' | egrep $WARNING_TSK > $TMP_2
      if [[ -s $TMP_2 ]]; then
         # Verify that any PIDS that were CRITICAL will not be counted as WARNING
         for i in `cat $PIDS`; do
            sed -i -e '/[a-zA-Z] .* '"`echo $i`"' .*$/d' $TMP_2
         done
         cat $TMP_2 |tee -a $TOPDIR
         # Copy WARNING PIDS to file to use for regex match
         cat $TMP_2 | awk -F' ' '{ print $5 }' >> $PIDS
      fi

      # INFO
      cat $TMP_1 | awk -F' ' '{ printf "%-10s %-10s %-10s %-10s %-10s %-10s\n", "INFO:", $1, $2, $3, $4, $5 }' | egrep $INFO_TSK > $TMP_2
      if [[ -s $TMP_2 ]]; then
         # Verify that any PIDS that were CRITICAL and/or WARNING will not be counted as INFO
         for i in `cat $PIDS`; do
            sed -i -e '/[a-zA-Z] .* '"`echo $i`"' .*$/d' $TMP_2
         done
         cat $TMP_2 |tee -a $TOPDIR
      fi

   ###############
   # OS == SOLARIS
   ###############
   else
      echo -e "\nALARM CPU USERNAME PID COMMAND" | awk '{ printf "%-10s %-10s %-10s %-10s %-10s\n\n", $1, $2, $3, $4, $5 }' |tee -a $TOPDIR

      # CRITICAL
      cat $TMP_1 | awk -F' ' '{ printf "%-10s %-10s %-10s %-10s %-10s\n", "CRITICAL:", $1, $2, $3, $4 }' | egrep $CRITICAL_TSK > $TMP_2
      if [[ -s $TMP_2 ]]; then
         cat $TMP_2 |tee -a $TOPDIR
      fi

      # WARNING
      cat $TMP_1 | awk -F' ' '{ printf "%-10s %-10s %-10s %-10s %-10s\n", "WARNING:", $1, $2, $3, $4 }' | egrep $WARNING_TSK > $TMP_2
      if [[ -s $TMP_2 ]]; then
         cat $TMP_2 |tee -a $TOPDIR
      fi

      # INFO
      cat $TMP_1 | awk -F' ' '{ printf "%-10s %-10s %-10s %-10s %-10s\n", "INFO:", $1, $2, $3, $4 }' | egrep $INFO_TSK > $TMP_2
      if [[ -s $TMP_2 ]]; then
         cat $TMP_2 |tee -a $TOPDIR
      fi
   fi

else
   echo system processes are in check
fi

# Cleanup Files
rm $TMP_1 2>/dev/null
rm $TMP_2 2>/dev/null
rm $TMP_11 2>/dev/null
rm $TMP_22 2>/dev/null
rm $TMP_12 2>/dev/null
rm $TMP_LINUX 2>/dev/null
rm $TMP_SOLARIS 2>/dev/null
rm $PIDS 2>/dev/null
