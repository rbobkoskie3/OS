#! /bin/bash

# ID: rb868x 8558 Nov 29 20:43 VerifyTOP_CPU.bash

clear

TOPDIR=/tmp/TOP
rm $TOPDIR 2>/dev/null
TMP_1=/tmp/TMP_1
TMP_2=/tmp/TMP_2
TMP_11=/tmp/TMP_11
TMP_22=/tmp/TMP_22
TMP_12=/tmp/TMP_12
TMP_OS=/tmp/OS
PIDS=/tmp/PIDS


# FILTER_ALL* set to capture any process running between 85 < PID < 199
# FILTER_ALL_TSK user to filter the list of tasks currently being managed by the kernel
# FILTER_ALL_AVE used to filter the average CPU utilization
# INFO_*, WARNING_*, CRITICAL_* are used for assigning priority to:
#                               *TSK --- the list of tasks currently being managed by the kernel
#                               *AVE ---  the average CPU utilization

INFO_TSK='8[5-9].*\%'
WARNING_TSK='9[0-5].*\%'
CRITICAL_TSK='9[6-9].*\%|1[0-9][0-9].*\%'
FILTER_ALL_TSK="^($INFO_TSK|$WARNING_TSK|$CRITICAL_TSK)"

INFO_AVE='8[5-9].*\%'
WARNING_AVE='9[0-5].*\%'
CRITICAL_AVE='9[6-9].*\%|1[0-9][0-9].*\%'
FILTER_ALL_AVE="^($INFO_TSK|$WARNING_TSK|$CRITICAL_TSK)"

BOOL_CRIT=false
BOOL_WARN=false

OS=`uname -s`

# OS == LINUX
if [ `echo $OS |grep -i linux` ]; then
   OS=linux
   ps -eo pcpu,pid,args | sort -k 1 -r | head -10 > $TMP_OS
   uptime >> $TMP_OS

   # Filter the list of tasks currently being managed by the kernel, looking for CPU utilization.
   # add "%" to designate fields with a 'percent' utilization, thus eliminating other numbers that may
   # fall in the range 85 < PID < 199 (e.g., PID), and thus be counted as an alarm.
   cat $TMP_OS | egrep '^[^a-zA-Z]' | awk -F' ' '{ printf "%-10s %-10s %-10s\n", $1"%", $2, $3 }' | egrep $FILTER_ALL_TSK > $TMP_1

   # Filter the average CPU utilization.
   # add "%" to designate fields with a 'percent' utilization. Use SED to eliminate the comma ',' from the number
   cat $TMP_OS | grep 'load' | awk -F' ' '{ printf "%-10s %-10s %-10s\n", $10"%", $11"%", $12"%" }' | sed s/,//g | egrep $FILTER_ALL_AVE > $TMP_11

# OS == SOLARIS
else
   OS=solaris
   OS=linux
   ps -eo pcpu,pid,args | sort -k 1 -r | head -10 > $TMP_OS
   uptime >> $TMP_OS

   # Filter the list of tasks currently being managed by the kernel, looking for CPU utilization.
   # add "%" to designate fields with a 'percent' utilization, thus eliminating other numbers that may
   # fall in the range 85 < PID < 199 (e.g., PID), and thus be counted as an alarm.
   cat $TMP_OS | egrep '^[^a-zA-Z]' | awk -F' ' '{ printf "%-10s %-10s %-10s\n", $1"%", $2, $3 }' | egrep $FILTER_ALL_TSK > $TMP_1

   # Filter the average CPU utilization.
   # add "%" to designate fields with a 'percent' utilization. Use SED to eliminate the comma ',' from the number
   cat $TMP_OS | grep 'load' | awk -F' ' '{ printf "%-10s %-10s %-10s\n", $10"%", $11"%", $12"%" }' | sed s/,//g | egrep $FILTER_ALL_AVE > $TMP_11
fi


#####################################
# Logic for assigning priority to the average CPU utilization
#####################################

if [[ -s $TMP_11 ]]; then
   echo CPU utilization is above thresholds, output also saved in $TOPDIR
   if [ $OS == linux ]; then
      echo -e "\nCPU PID COMMAND" | awk '{ printf "%-10s %-10s %-10s\n\n", $1, $2, $3 }' |tee -a $TOPDIR
   else
      echo -e "\nCPU PID COMMAND" | awk '{ printf "%-10s %-10s %-10s\n\n", $1, $2, $3 }' |tee -a $TOPDIR
   fi
else
   echo CPU utilization in check
fi

# CRITICAL
if [ $OS == linux ]; then
   cat $TMP_11 | awk -F' ' '{ printf "%-10s %-10s %-10s %-10s %-10s %-10s %-10s %-10s\n", "CRITICAL:", $2, $3, $4, $5, $6, $7, $8 }' | egrep $CRITICAL_AVE > $TMP_22
   if [[ -s $TMP_22 ]]; then
      cat $TMP_22 |tee -a $TOPDIR
      BOOL_CRIT=true
   fi
else
   cat $TMP_11 | awk -F' ' '{ printf "%-10s %-10s %-10s %-10s %-10s\n", "CRITICAL:", $1, $3, $5, $7 }' | egrep $CRITICAL_AVE > $TMP_22
   if [[ -s $TMP_22 ]]; then
      cat $TMP_22 |tee -a $TOPDIR
      BOOL_CRIT=true
   fi
fi

# WARNING
if [ $BOOL_CRIT == false ]; then
   if [ $OS == linux ]; then
      cat $TMP_11 | awk -F' ' '{ printf "%-10s %-10s %-10s %-10s %-10s %-10s %-10s %-10s\n", "WARNING:", $2, $3, $4, $5, $6, $7, $8 }' | egrep $WARNING_AVE > $TMP_22
      if [[ -s $TMP_22 ]]; then
         cat $TMP_22 |tee -a $TOPDIR
         BOOL_WARN=true
      fi
   else
      cat $TMP_11 | awk -F' ' '{ printf "%-10s %-10s %-10s %-10s %-10s\n", "WARNING:", $1, $3, $5, $7 }' | egrep $WARNING_AVE > $TMP_22
      if [[ -s $TMP_22 ]]; then
         cat $TMP_22 |tee -a $TOPDIR
         BOOL_WARN=true
      fi
   fi
fi

# INFO
if [[ $BOOL_CRIT == false && $BOOL_WARN == false ]]; then
   if [ $OS == linux ]; then
      cat $TMP_11 | awk -F' ' '{ printf "%-10s %-10s %-10s %-10s %-10s %-10s %-10s %-10s\n", "INFO:", $2, $3, $4, $5, $6, $7i, $8 }' | egrep $INFO_AVE > $TMP_22
      if [[ -s $TMP_22 ]]; then
         cat $TMP_22 |tee -a $TOPDIR
      fi
   else
      cat $TMP_11 | awk -F' ' '{ printf "%-10s %-10s %-10s %-10s %-10s\n", "INFO:", $1, $3, $5, $7 }' | egrep $INFO_AVE > $TMP_22
      if [[ -s $TMP_22 ]]; then
         cat $TMP_22 |tee -a $TOPDIR
      fi
   fi
fi


#####################################
# Logic for assigning priority to the list of tasks currently being managed by the kernel
#####################################

if [[ -s $TMP_1 ]]; then
   echo The following processes are using resources, output also saved in $TOPDIR
   if [ $OS == linux ]; then
      echo -e "\nALARM CPU MEM USER PID COMMAND" | awk '{ printf "%-10s %-10s %-10s %-10s %-10s %-10s\n\n", $1, $2, $3, $4, $5, $6 }' |tee -a $TOPDIR
   else
      echo -e "\nALARM CPU USERNAME PID COMMAND" | awk '{ printf "%-10s %-10s %-10s %-10s %-10s\n\n", $1, $2, $3, $4, $5 }' |tee -a $TOPDIR
   fi
else
   echo system processes are in check

   # Cleanup Files
   rm $TMP_1 2>/dev/null
   rm $TMP_2 2>/dev/null
   rm $TMP_11 2>/dev/null
   rm $TMP_22 2>/dev/null
   rm $TMP_12 2>/dev/null
   rm $TMP_OS 2>/dev/null
   rm $PIDS 2>/dev/null
   exit 1
fi

# CRITICAL
if [ $OS == linux ]; then
   cat $TMP_1 | awk -F' ' '{ printf "%-10s %-10s %-10s %-10s %-10s %-10s\n", "CRITICAL:", $1, $2, $3, $4, $5 }' | egrep $CRITICAL_TSK > $TMP_2
   if [[ -s $TMP_2 ]]; then
      cat $TMP_2 |tee -a $TOPDIR
      # Copy CRITICAL PIDS to file to use for regex match '>' overwrite $PIDS
      cat $TMP_2 | awk -F' ' '{ print $5 }' > $PIDS
   fi
else
   cat $TMP_1 | awk -F' ' '{ printf "%-10s %-10s %-10s %-10s %-10s\n", "CRITICAL:", $1, $2, $3, $4 }' | egrep $CRITICAL_TSK > $TMP_2
   if [[ -s $TMP_2 ]]; then
      cat $TMP_2 |tee -a $TOPDIR
   fi
fi

# WARNING
if [ $OS == linux ]; then
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
else
   cat $TMP_1 | awk -F' ' '{ printf "%-10s %-10s %-10s %-10s %-10s\n", "WARNING:", $1, $2, $3, $4 }' | egrep $WARNING_TSK > $TMP_2
   if [[ -s $TMP_2 ]]; then
      cat $TMP_2 |tee -a $TOPDIR
   fi
fi

# INFO
if [ $OS == linux ]; then
   cat $TMP_1 | awk -F' ' '{ printf "%-10s %-10s %-10s %-10s %-10s %-10s\n", "INFO:", $1, $2, $3, $4, $5 }' | egrep $INFO_TSK > $TMP_2
   if [[ -s $TMP_2 ]]; then
      # Verify that any PIDS that were CRITICAL and/or WARNING will not be counted as INFO
      for i in `cat $PIDS`; do
         sed -i -e '/[a-zA-Z] .* '"`echo $i`"' .*$/d' $TMP_2
      done
      cat $TMP_2 |tee -a $TOPDIR
   fi
else
   cat $TMP_1 | awk -F' ' '{ printf "%-10s %-10s %-10s %-10s %-10s\n", "INFO:", $1, $2, $3, $4 }' | egrep $INFO_TSK > $TMP_2
   if [[ -s $TMP_2 ]]; then
      cat $TMP_2 |tee -a $TOPDIR
   fi
fi

rm $TMP_1 2>/dev/null
rm $TMP_2 2>/dev/null
rm $TMP_11 2>/dev/null
rm $TMP_22 2>/dev/null
rm $TMP_12 2>/dev/null
rm $TMP_OS 2>/dev/null
rm $PIDS 2>/dev/null
