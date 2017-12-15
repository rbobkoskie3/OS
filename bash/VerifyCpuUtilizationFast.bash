#! /bin/bash

# ID: rb868x 11919 Dec 22 19:33 VerifyCpuUtilizationFast.bash
# Tested on Solaris 10, Red Hat 5.3

clear

################################################
# VerifyTOP_CPU.bash will look for CPU utilization,
# as well as tasks currently being managed by
# the kernel. Based on filters, an the program will
# generate an output file with [CRITICAL WARNING INFO]
# 'ALARMS'.
################################################


# Delete output file prior to each run
TOPDIR=/tmp/TOP
rm $TOPDIR 2>/dev/null

TMP_1=/tmp/TMP_1_`echo $(date +%Y%m%d-%H%M%S)`
TMP_2=/tmp/TMP_2_`echo $(date +%Y%m%d-%H%M%S)`
TMP_11=/tmp/TMP_11_`echo $(date +%Y%m%d-%H%M%S)`
TMP_22=/tmp/TMP_22_`echo $(date +%Y%m%d-%H%M%S)`
TMP_OS=/tmp/OS_`echo $(date +%Y%m%d-%H%M%S)`


# FILTER_ALL* set to capture any process running between 85 < PID < 199
# FILTER_ALL_TSK user to filter the list of tasks currently being managed by the kernel
# FILTER_ALL_AVE used to filter the average CPU utilization
# INFO_*, WARNING_*, CRITICAL_* are used for assigning priority to:
#                               *TSK --- the list of tasks currently being managed by the kernel
#                               *AVE ---  the average CPU utilization

INFO_TSK='8[5-9]\..*\%'
WARNING_TSK='9[0-5]\..*\%'
CRITICAL_TSK='9[6-9]\..*\%|1[0-9][0-9]\..*\%'
FILTER_ALL_TSK="^($INFO_TSK|$WARNING_TSK|$CRITICAL_TSK)"

INFO_AVE='8[5-9]\..*\%'
WARNING_AVE='9[0-5]\..*\%'
CRITICAL_AVE='9[6-9]\..*\%|1[0-9][0-9]\..*\%'
FILTER_ALL_AVE="($INFO_TSK|$WARNING_TSK|$CRITICAL_TSK)"

BOOL_CRIT=false
BOOL_WARN=false

OS=`uname -s`

###############
# OS == LINUX
if [ `echo $OS |grep -i linux` ]; then
   OS=linux
###############

   ps -eo pcpu,pid,args | sort -k 1 -r | head -10 > $TMP_OS
   uptime | awk -F':' '{ printf "LOAD " $5"\n" }' >> $TMP_OS

   # Filter the list of tasks currently being managed by the kernel, looking for CPU utilization.
   # add "%" to designate fields with a 'percent' utilization, thus eliminating other numbers that may
   # fall in the range 85 < PID < 199 (e.g., PID), and thus be counted as an alarm.
   cat $TMP_OS | egrep '^[^a-zA-Z]' | awk -F' ' '{ printf "%-10s %-10s %-10s\n", $1"%", $2, $3 }' | egrep $FILTER_ALL_TSK > $TMP_1

   # Filter the average CPU utilization.
   # add "%" to designate fields with a 'percent' utilization. Use SED to eliminate the comma ',' from the number
   cat $TMP_OS | grep 'load' | sed s/,//g | awk -F' ' '{ printf "%-10s %-10s %-10s\n", $10"%", $11"%", $12"%" }' | egrep $FILTER_ALL_AVE > $TMP_11

###############
# OS == SOLARIS
else
   OS=solaris
###############

   ps -eo pcpu,pid,args | sort -k 1 -r | head -10 > $TMP_OS
   uptime | awk -F':' '{ printf "LOAD " $4"\n" }' >> $TMP_OS

   # Filter the list of tasks currently being managed by the kernel, looking for CPU utilization.
   # add "%" to designate fields with a 'percent' utilization, thus eliminating other numbers that may
   # fall in the range 85 < PID < 199 (e.g., PID), and thus be counted as an alarm.
   cat $TMP_OS | egrep '^[^a-zA-Z]' | awk -F' ' '{ printf "%-10s %-10s %-10s\n", $1"%", $2, $3 }' | egrep $FILTER_ALL_TSK > $TMP_1

   # Filter the average CPU utilization.
   # add "%" to designate fields with a 'percent' utilization. Use SED to eliminate the comma ',' from the number
   cat $TMP_OS | grep 'load' | sed s/,//g | awk -F' ' '{ printf "%-10s %-10s %-10s\n", $10"%", $11"%", $12"%" }' | egrep $FILTER_ALL_AVE > $TMP_11
fi


#####################################
# Logic for assigning priority to the average CPU utilization
#####################################

if [[ -s $TMP_11 ]]; then
   echo CPU utilization is above thresholds, output also saved in $TOPDIR

   ###############
   # OS == LINUX
   ###############
   if [ $OS == linux ]; then
      echo -e "\nALARM LoadAve-1 LoadAve-5 LoadAve-15 NOTE" | awk '{ printf "%-10s %-10s %-10s %-12s %-30s\n\n", $1, $2, $3, $4, $5 }' |tee -a $TOPDIR

      # CRITICAL
      cat $TMP_11 | awk -F' ' '{ printf "%-10s %-10s %-10s %-10s\n", "CRITICAL:", $1, $2, $3 }' | egrep $CRITICAL_AVE > $TMP_22
      if [[ -s $TMP_22 ]]; then
         cat $TMP_22 |tee -a $TOPDIR
         BOOL_CRIT=true
      fi

      # WARNING
      if [ $BOOL_CRIT == false ]; then
         cat $TMP_11 | awk -F' ' '{ printf "%-10s %-10s %-10s %-10s\n", "WARNING:", $1, $2, $3 }' | egrep $WARNING_AVE > $TMP_22
         if [[ -s $TMP_22 ]]; then
            cat $TMP_22 |tee -a $TOPDIR
            BOOL_WARN=true
         fi
      fi

      # INFO
      if [[ $BOOL_CRIT == false && $BOOL_WARN == false ]]; then
         cat $TMP_11 | awk -F' ' '{ printf "%-10s %-10s %-10s %-10s\n", "INFO:", $1, $2, $3 }' | egrep $INFO_AVE > $TMP_22
         if [[ -s $TMP_22 ]]; then
            cat $TMP_22 |tee -a $TOPDIR
         fi
      fi

      # Check for increase in 1' CPU Util, S.T. 1' CPU Util > [5 | 15]' CPU Util. Same for 5' CPU Util, e.g., 5' > 15'. Write as INFO.
      cat $TMP_OS | grep 'LOAD' | sed s/,//g | awk -F' ' '{ if ($2 > $3) printf "%-10s %-10s %-10s %-12s %-30s\n", "INFO:", $2"%", $3"%", "", "1 minute CPU Util is > 5 minute CPU Util" }'  > $TMP_22
      cat $TMP_OS | grep 'LOAD' | sed s/,//g | awk -F' ' '{ if ($2 > $4) printf "%-10s %-10s %-10s %-12s %-30s\n", "INFO:", $2"%", "", $4"%", "1 minute CPU Util is > 15 minute CPU Util" }' >> $TMP_22
      cat $TMP_OS | grep 'LOAD' | sed s/,//g | awk -F' ' '{ if ($3 > $4) printf "%-10s %-10s %-10s %-12s %-30s\n", "INFO:", "", $3"%", $4"%", "5 minute CPU Util is > 15 minute CPU Util" }' >> $TMP_22
      if [[ -s $TMP_22 ]]; then
         cat $TMP_22 |tee -a $TOPDIR
      fi

   ###############
   # OS == SOLARIS
   ###############
   else
      echo -e "\nALARM LoadAve-1 LoadAve-5 LoadAve-15 NOTE" | awk '{ printf "%-10s %-10s %-10s %-12s %-30s\n\n", $1, $2, $3, $4, $5 }' |tee -a $TOPDIR

      # CRITICAL
      cat $TMP_11 | awk -F' ' '{ printf "%-10s %-10s %-10s %-10s\n", "CRITICAL:", $1, $2, $3 }' | egrep $CRITICAL_AVE > $TMP_22
      if [[ -s $TMP_22 ]]; then
         cat $TMP_22 |tee -a $TOPDIR
         BOOL_CRIT=true
      fi

      # WARNING
      if [ $BOOL_CRIT == false ]; then
         cat $TMP_11 | awk -F' ' '{ printf "%-10s %-10s %-10s %-10s\n", "WARNING:", $1, $2, $3 }' | egrep $WARNING_AVE > $TMP_22
         if [[ -s $TMP_22 ]]; then
            cat $TMP_22 |tee -a $TOPDIR
            BOOL_WARN=true
         fi
      fi

      # INFO
      if [[ $BOOL_CRIT == false && $BOOL_WARN == false ]]; then
         cat $TMP_11 | awk -F' ' '{ printf "%-10s %-10s %-10s %-10s\n", "INFO:", $1, $2, $3 }' | egrep $INFO_AVE > $TMP_22
         if [[ -s $TMP_22 ]]; then
            cat $TMP_22 |tee -a $TOPDIR
         fi
      fi

      # Check for increase in 1' CPU Util, S.T. 1' CPU Util > [5 | 15]' CPU Util. Same for 5' CPU Util, e.g., 5' > 15'. Write as INFO.
      cat $TMP_OS | grep 'LOAD' | sed s/,//g | awk -F' ' '{ if ($2 > $3) printf "%-10s %-10s %-10s %-12s %-30s\n", "INFO:", $2"%", $3"%", "", "1 minute CPU Util is > 5 minute CPU Util" }'  > $TMP_22
      cat $TMP_OS | grep 'LOAD' | sed s/,//g | awk -F' ' '{ if ($2 > $4) printf "%-10s %-10s %-10s %-12s %-30s\n", "INFO:", $2"%", "", $4"%", "1 minute CPU Util is > 15 minute CPU Util" }' >> $TMP_22
      cat $TMP_OS | grep 'LOAD' | sed s/,//g | awk -F' ' '{ if ($3 > $4) printf "%-10s %-10s %-10s %-12s %-30s\n", "INFO:", "", $3"%", $4"%", "5 minute CPU Util is > 15 minute CPU Util" }' >> $TMP_22
      if [[ -s $TMP_22 ]]; then
         cat $TMP_22 |tee -a $TOPDIR
      fi
   fi

else
   echo CPU utilization does not exceed thresholds

   # NOTE: Due to conditional, if [[ -s $TMP_11 ]], e.g., CPU Util exceeded thresholds --- Need to check CPU Util [1 5 15]' here, at the 'else'.
   # Check for increase in 1' CPU Util, S.T. 1' CPU Util > [5 | 15]' CPU Util. Same for 5' CPU Util, e.g., 5' > 15'. Write as INFO.
   if [ $OS == linux ]; then
      cat $TMP_OS | grep 'LOAD' | sed s/,//g | awk -F' ' '{ if ($2 > $3) printf "%-10s %-10s %-10s %-12s %-30s\n", "INFO:", $2"%", $3"%", "", "1 minute CPU Util is > 5 minute CPU Util" }'  > $TMP_22
      cat $TMP_OS | grep 'LOAD' | sed s/,//g | awk -F' ' '{ if ($2 > $4) printf "%-10s %-10s %-10s %-12s %-30s\n", "INFO:", $2"%", "", $4"%", "1 minute CPU Util is > 15 minute CPU Util" }' >> $TMP_22
      cat $TMP_OS | grep 'LOAD' | sed s/,//g | awk -F' ' '{ if ($3 > $4) printf "%-10s %-10s %-10s %-12s %-30s\n", "INFO:", "", $3"%", $4"%", "5 minute CPU Util is > 15 minute CPU Util" }' >> $TMP_22
      if [[ -s $TMP_22 ]]; then
         echo "CPU utilization for 1' has exceeded either 5' or 15 interval', and/or 5' has exceeded 15' interval, output also saved in $TOPDIR"
         echo -e "\nALARM LoadAve-1 LoadAve-5 LoadAve-15 NOTE" | awk '{ printf "%-10s %-10s %-10s %-12s %-30s\n\n", $1, $2, $3, $4, $5 }' |tee -a $TOPDIR
         cat $TMP_22 |tee -a $TOPDIR
      fi
   else
      cat $TMP_OS | grep 'LOAD' | sed s/,//g | awk -F' ' '{ if ($2 > $3) printf "%-10s %-10s %-10s %-12s %-30s\n", "INFO:", $2"%", $3"%", "", "1 minute CPU Util is > 5 minute CPU Util" }'  > $TMP_22
      cat $TMP_OS | grep 'LOAD' | sed s/,//g | awk -F' ' '{ if ($2 > $4) printf "%-10s %-10s %-10s %-12s %-30s\n", "INFO:", $2"%", "", $4"%", "1 minute CPU Util is > 15 minute CPU Util" }' >> $TMP_22
      cat $TMP_OS | grep 'LOAD' | sed s/,//g | awk -F' ' '{ if ($3 > $4) printf "%-10s %-10s %-10s %-12s %-30s\n", "INFO:", "", $3"%", $4"%", "5 minute CPU Util is > 15 minute CPU Util" }' >> $TMP_22
      if [[ -s $TMP_22 ]]; then
         echo "CPU utilization for 1' has exceeded either 5' or 15 interval', and/or 5' has exceeded 15' interval, output also saved in $TOPDIR"
         echo -e "\nALARM LoadAve-1 LoadAve-5 LoadAve-15 NOTE" | awk '{ printf "%-10s %-10s %-10s %-12s %-30s\n\n", $1, $2, $3, $4, $5 }' |tee -a $TOPDIR
         cat $TMP_22 |tee -a $TOPDIR
      fi
   fi
fi


#####################################
# Logic for assigning priority to the list of tasks currently being managed by the kernel
#####################################

if [[ -s $TMP_1 ]]; then
   echo -e "\nThe following processes are using resources, output also saved in $TOPDIR"

   ###############
   # OS == LINUX
   ###############
   if [ $OS == linux ]; then
      echo -e "\nALARM CPU PID COMMAND" | awk '{ printf "%-10s %-10s %-10s %-10s\n\n", $1, $2, $3, $4 }' |tee -a $TOPDIR

      # CRITICAL
      cat $TMP_1 | awk -F' ' '{ printf "%-10s %-10s %-10s %-10s\n", "CRITICAL:", $1, $2, $3 }' | egrep $CRITICAL_TSK > $TMP_2
      if [[ -s $TMP_2 ]]; then
         cat $TMP_2 |tee -a $TOPDIR
      fi

      # WARNING
      cat $TMP_1 | awk -F' ' '{ printf "%-10s %-10s %-10s %-10s\n", "WARNING:", $1, $2, $3 }' | egrep $WARNING_TSK > $TMP_2
      if [[ -s $TMP_2 ]]; then
         cat $TMP_2 |tee -a $TOPDIR
      fi

      # INFO
      cat $TMP_1 | awk -F' ' '{ printf "%-10s %-10s %-10s %-10s\n", "INFO:", $1, $2, $3 }' | egrep $INFO_TSK > $TMP_2
      if [[ -s $TMP_2 ]]; then
         cat $TMP_2 |tee -a $TOPDIR
      fi

   ###############
   # OS == SOLARIS
   ###############
   else
      echo -e "\nALARM CPU PID COMMAND" | awk '{ printf "%-10s %-10s %-10s %-10s\n\n", $1, $2, $3, $4 }' |tee -a $TOPDIR

      # CRITICAL
      cat $TMP_1 | awk -F' ' '{ printf "%-10s %-10s %-10s %-10s\n", "CRITICAL:", $1, $2, $3 }' | egrep $CRITICAL_TSK > $TMP_2
      if [[ -s $TMP_2 ]]; then
         cat $TMP_2 |tee -a $TOPDIR
      fi

      # WARNING
      cat $TMP_1 | awk -F' ' '{ printf "%-10s %-10s %-10s %-10s\n", "WARNING:", $1, $2, $3 }' | egrep $WARNING_TSK > $TMP_2
      if [[ -s $TMP_2 ]]; then
         cat $TMP_2 |tee -a $TOPDIR
      fi

      # INFO
      cat $TMP_1 | awk -F' ' '{ printf "%-10s %-10s %-10s %-10s\n", "INFO:", $1, $2, $3 }' | egrep $INFO_TSK > $TMP_2
      if [[ -s $TMP_2 ]]; then
         cat $TMP_2 |tee -a $TOPDIR
      fi
   fi

else
   echo system processes are in check
fi


rm $TMP_1 2>/dev/null
rm $TMP_2 2>/dev/null
rm $TMP_11 2>/dev/null
rm $TMP_22 2>/dev/null
rm $TMP_OS 2>/dev/null
