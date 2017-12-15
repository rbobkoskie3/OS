#! /bin/bash

# ID: 3063 Jan 26 17:01 Verify_ConnectivityAsFloodXfr.bash
# Tested on Solaris 10

clear

################################################
# Verify_Connectivity.bash checks for both socket
# and ssh connectivity.
# First, Socket connectivity is verified via telnet.
# Then ssh connectivity is verified.
# Based on results, the
# program will generate an output file with
# [CRITICAL WARNING INFO] 'ALARMS'.
################################################


if [ ! -w ~floodxfr ]; then
   echo "\"$USER\" cannot execute this command...must be root.  Exiting..."
   exit 1
fi


CONNECTIVITY=/tmp/CONNECTIVITY_PUSHDB
CONNECTIVITY_INFO=/tmp/CONNECTIVITY_INFO_PUSHDB
CONNECTIVITY_WARNING=/tmp/CONNECTIVITY_WARNING_PUSHDB
VERIFY_CONNECTION=/tmp/VERIFY_CONNECTION_PUSHDB
VERIFY_SOCKET=/tmp/VERIFY_SOCKET_PUSHDB

rm $CONNECTIVITY 2>/dev/null

##########################################
# Determine Role, if not Report Server, then exit
FQDN=`floodenv whoHasRole -h database`
##########################################

if [ `hostname` != $FQDN ]; then
   echo INFO: | awk '{ printf "%-15s %-30s %-30s\n", $1, "THIS IS NOT A REPORT SERVER", "THIS TEST ONLY RUNS ON A REPORT SERVER" }' |tee -a $CONNECTIVITY
   exit 2
fi


# Verify Connectivity
echo Connectivity will be verified, results saved to $CONNECTIVITY

##########################################
# Datacache
FQDN=`floodenv whoHasRole -f datacache`
##########################################
if [ $FQDN ]; then


   ##########################################
   # Verify Connectivity (PUSH FILES, ID=floodxfr, , via Port 22) to Secaucus Datacache VIP
   PORT=22
   ##########################################

   telnet $FQDN $PORT 1>$VERIFY_SOCKET 2>&1&
   sleep 1
   kill -9 $! 1>/dev/null 2>&1

   if grep 'Connect.* to' $VERIFY_SOCKET 1>/dev/null 2>&1; then
      echo $FQDN | awk '{ printf "%-15s %-30s %-30s %-20s\n", "INFO:", $1, "Secaucus DBC VIP (PORT 22)", "SOCKET UP" }' >> $CONNECTIVITY_INFO

      ssh -i ~floodxfr/.ssh/batch_remote floodxfr@$FQDN hostname > $VERIFY_CONNECTION
      if [ $? -ne 0 ]; then
         echo $FQDN | awk '{ printf "%-15s %-30s %-30s %-20s\n", "CRITICAL:", $1, "Secaucus DBC VIP (PUSH FILES)", "NO SSH CONNECTIVITY" }' |tee -a $CONNECTIVITY
      else
         echo $FQDN | awk '{ printf "%-15s %-30s %-30s %-20s\n", "INFO:", $1, "Secaucus DBC VIP (PUSH FILES)", "SSH CONNECTIVITY OK" }' >> $CONNECTIVITY_INFO
      fi
   else
      echo $FQDN | awk '{ printf "%-15s %-30s %-30s %-20s\n", "CRITICAL:", $1, "Secaucus DBC VIP (PORT 22)", "SOCKET DOWN" }' |tee -a $CONNECTIVITY
   fi
fi

##########################################
# Append files s.t. the CRITICAL messages
# are displayed first in the log file
##########################################
if [[ -s $CONNECTIVITY_WARNING ]]; then
   cat $CONNECTIVITY_WARNING >> $CONNECTIVITY
fi

if [[ -s $CONNECTIVITY_INFO ]]; then
   cat $CONNECTIVITY_INFO >> $CONNECTIVITY
fi

rm $VERIFY_CONNECTION 2>/dev/null
rm $CONNECTIVITY_INFO 2>/dev/null
rm $CONNECTIVITY_WARNING 2>/dev/null
rm $VERIFY_SOCKET 2>/dev/null
