#! /bin/bash

# ID: rb868x 10952 Dec 15 22:02 Verify_Connectivity.bash
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


CONNECTIVITY=/tmp/CONNECTIVITY
CONNECTIVITY_INFO=/tmp/CONNECTIVITY_INFO
CONNECTIVITY_WARNING=/tmp/CONNECTIVITY_WARNING
VERIFY_CONNECTION=/tmp/VERIFY_CONNECTION
VERIFY_SOCKET=/tmp/VERIFY_SOCKET

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
   # Verify Connectivity (PUSH DB, ID=flood, via Port 22) to Secaucus Datacache VIP
   PORT=22
   ##########################################

   telnet $FQDN $PORT 1>$VERIFY_SOCKET 2>&1&
   sleep 1
   kill -9 $! 1>/dev/null 2>&1

   if grep 'Connect.* to' $VERIFY_SOCKET 1>/dev/null 2>&1; then
      echo $FQDN | awk '{ printf "%-15s %-30s %-30s %-20s\n", "INFO:", $1, "Secaucus DBC VIP (PORT 22)", "SOCKET UP" }' >> $CONNECTIVITY_INFO
      su flood -c "ssh -i ~flood/.ssh/batch_remote floodxfr@$FQDN hostname" > $VERIFY_CONNECTION
      if [ $? -ne 0 ]; then
         echo $FQDN | awk '{ printf "%-15s %-30s %-30s %-20s\n", "CRITICAL:", $1, "Secaucus DBC VIP (PUSH DB)", "NO SSH CONNECTIVITY" }' |tee -a $CONNECTIVITY
      else
         echo $FQDN | awk '{ printf "%-15s %-30s %-30s %-20s\n", "INFO:", $1, "Secaucus DBC VIP (PUSH DB)", "SSH CONNECTIVITY OK" }' >> $CONNECTIVITY_INFO
      fi

      ##########################################
      # Verify Connectivity (PUSH FILES, ID=floodxfr, , via Port 22) to Secaucus Datacache VIP
      ##########################################

      su floodxfr -c "ssh -i ~floodxfr/.ssh/batch_remote floodxfr@$FQDN hostname" > $VERIFY_CONNECTION
      if [ $? -ne 0 ]; then
         echo $FQDN | awk '{ printf "%-15s %-30s %-30s %-20s\n", "CRITICAL:", $1, "Secaucus DBC VIP (PUSH FILES)", "NO SSH CONNECTIVITY" }' |tee -a $CONNECTIVITY
      else
         echo $FQDN | awk '{ printf "%-15s %-30s %-30s %-20s\n", "INFO:", $1, "Secaucus DBC VIP (PUSH FILES)", "SSH CONNECTIVITY OK" }' >> $CONNECTIVITY_INFO
      fi
   else
      echo $FQDN | awk '{ printf "%-15s %-30s %-30s %-20s\n", "CRITICAL:", $1, "Secaucus DBC VIP (PORT 22)", "SOCKET DOWN" }' |tee -a $CONNECTIVITY
   fi

   ##########################################
   # Verify Connectivity (via Port 9017) to Secaucus Datacache VIP
   # NOTE --- This test calls the Python script "Verify_Connectivity_DBC_9017.py"
   PORT=9017
   ##########################################

   telnet $FQDN $PORT 1>$VERIFY_SOCKET 2>&1&
   sleep 1
   kill -9 $! 1>/dev/null 2>&1

   if grep 'Connect.* to' $VERIFY_SOCKET 1>/dev/null 2>&1; then
      echo $FQDN | awk '{ printf "%-15s %-30s %-30s %-20s\n", "INFO:", $1, "Secaucus DBC VIP (PORT 9017)", "SOCKET UP" }' >> $CONNECTIVITY_INFO
      su flood -c "floodenv python-flood Verify_Connectivity_DBC_9017.py" > $VERIFY_CONNECTION
      grep -i error $VERIFY_CONNECTION 1>/dev/null 2>&1
      if [ $? -eq 0 ]; then
         echo $FQDN | awk '{ printf "%-15s %-30s %-30s %-20s\n", "CRITICAL:", $1, "Secaucus DBC VIP (PORT 9017)", "NO SSH CONNECTIVITY" }' |tee -a $CONNECTIVITY
      else
         echo $FQDN | awk '{ printf "%-15s %-30s %-30s %-20s\n", "INFO:", $1, "Secaucus DBC VIP (PORT 9017)", "SSH CONNECTIVITY OK" }' >> $CONNECTIVITY_INFO
      fi
   else
      echo $FQDN | awk '{ printf "%-15s %-30s %-30s %-20s\n", "CRITICAL:", $1, "Secaucus DBC VIP (PORT 9017)", "SOCKET DOWN" }' |tee -a $CONNECTIVITY
   fi

else
   echo DATACACHE | awk '{ printf "%-15s %-30s %-30s\n", "WARNING:", $1, "Role Not Defined" }' |tee -a $CONNECTIVITY_WARNING
fi

##########################################
# APP 
FQDN=`floodenv whoHasRole -f appserver`
##########################################
if [ $FQDN ]; then

   ##########################################
   # Verify Connectivity (via Port 50025) to Secaucus APP VIP
   PORT=50025
   ##########################################

   telnet $FQDN $PORT 1>$VERIFY_SOCKET 2>&1&
   sleep 1
   kill -9 $! 1>/dev/null 2>&1

   if grep 'Connect.* to' $VERIFY_SOCKET 1>/dev/null 2>&1; then
      echo $FQDN | awk '{ printf "%-15s %-30s %-30s %-20s\n", "INFO:", $1, "Secaucus APP VIP (PORT 50025)", "SOCKET UP" }' >> $CONNECTIVITY_INFO
   else
      echo $FQDN | awk '{ printf "%-15s %-30s %-30s %-20s\n", "CRITICAL:", $1, "Secaucus APP VIP (PORT 50025)", "SOCKET DOWN" }' |tee -a $CONNECTIVITY
   fi

else
   echo IGW | awk '{ printf "%-15s %-30s %-30s\n", "WARNING:", $1, "Role Not Defined" }' |tee -a $CONNECTIVITY_WARNING
fi


##########################################
# IGW
##########################################

##########################################
# Verify Connectivity (via Port 9017) to Secaucus IGW VIP
# NOTE --- This test calls the Python script "Verify_Connectivity_IGW_9017.py"
PORT=9017
FQDN=`floodenv whoHasRole -f digger`
##########################################
if [ $FQDN ]; then

   telnet $FQDN $PORT 1>$VERIFY_SOCKET 2>&1&
   sleep 1
   kill -9 $! 1>/dev/null 2>&1

   if grep 'Connect.* to' $VERIFY_SOCKET 1>/dev/null 2>&1; then
      echo $FQDN | awk '{ printf "%-15s %-30s %-30s %-20s\n", "INFO:", $1, "Secaucus IGW VIP (PORT 9017)", "SOCKET UP" }' >> $CONNECTIVITY_INFO
      su flood -c "floodenv python-flood Verify_Connectivity_IGW_9017.py" > $VERIFY_CONNECTION
      grep -i error $VERIFY_CONNECTION 1>/dev/null 2>&1
      if [ $? -eq 0 ]; then
         echo $FQDN | awk '{ printf "%-15s %-30s %-30s %-20s\n", "CRITICAL:", $1, "Secaucus IGW VIP (9017)", "NO SSH CONNECTIVITY" }' |tee -a $CONNECTIVITY
      else
         echo $FQDN | awk '{ printf "%-15s %-30s %-30s %-20s\n", "INFO:", $1, "Secaucus IGW VIP (9017)", "SSH CONNECTIVITY OK" }' >> $CONNECTIVITY_INFO
      fi
   else
      echo $FQDN | awk '{ printf "%-15s %-30s %-30s %-20s\n", "CRITICAL:", $1, "Secaucus IGW VIP (PORT 9017)", "SOCKET DOWN" }' |tee -a $CONNECTIVITY
   fi

else
   echo IGW | awk '{ printf "%-15s %-30s %-30s\n", "WARNING:", $1, "Role Not Defined" }' |tee -a $CONNECTIVITY_WARNING
fi

##########################################
# Verify Connectivity (via Port 50110) to Secaucus IGW VIP
PORT=50110
FQDN=`floodenv whoHasRole -f pkflowlistener`
##########################################
if [ $FQDN ]; then
   telnet $FQDN $PORT 1>$VERIFY_SOCKET 2>&1&
   sleep 1
   kill -9 $! 1>/dev/null 2>&1

   if grep 'Connect.* to' $VERIFY_SOCKET 1>/dev/null 2>&1; then
      echo $FQDN | awk '{ printf "%-15s %-30s %-30s %-20s\n", "INFO:", $1, "Secaucus IGW VIP (PORT 50110)", "SOCKET UP" }' >> $CONNECTIVITY_INFO
   else
      echo $FQDN | awk '{ printf "%-15s %-30s %-30s %-20s\n", "CRITICAL:", $1, "Secaucus IGW VIP (PORT 50110)", "SOCKET DOWN" }' |tee -a $CONNECTIVITY
   fi

else
   echo IGW | awk '{ printf "%-15s %-30s %-30s\n", "WARNING:", $1, "Role Not Defined" }' |tee -a $CONNECTIVITY_WARNING
fi


##########################################
# Fathom
FQDN=`floodenv whoHasRole -f fathomserver`
##########################################
if [ $FQDN ]; then

   ##########################################
   # Verify Connectivity to Fathom DBC VIP
   PORT=9019
   ##########################################

   telnet $FQDN $PORT 1>$VERIFY_SOCKET 2>&1&
   sleep 1
   kill -9 $! 1>/dev/null 2>&1

   if grep 'Connect.* to' $VERIFY_SOCKET 1>/dev/null 2>&1; then
      echo $FQDN | awk '{ printf "%-15s %-30s %-30s %-20s\n", "INFO:", $1, "Fathom DBC VIP (PORT 9019)", "SOCKET UP" }' >> $CONNECTIVITY_INFO
      su flood -c "ssh -p $PORT -i ~flood/.ssh/fathom_srv_grp_dsa fathom@$FQDN hostname" > $VERIFY_CONNECTION
      if [ $? -ne 0 ]; then
         echo $FQDN | awk '{ printf "%-15s %-30s %-30s %-20s\n", "CRITICAL:", $1, "Fathom DBC VIP (PORT 9019)", "NO SSH CONNECTIVITY" }' |tee -a $CONNECTIVITY
      else
         echo $FQDN | awk '{ printf "%-15s %-30s %-30s %-20s\n", "INFO:", $1, "Fathom DBC VIP (PORT 9019)", "SSH CONNECTIVITY OK" }' >> $CONNECTIVITY_INFO
      fi
   else
      echo $FQDN | awk '{ printf "%-15s %-30s %-30s %-20s\n", "CRITICAL:", $1, "Fathom DBC VIP (PORT 9019)", "SOCKET DOWN" }' |tee -a $CONNECTIVITY
   fi

else
   echo FATHOM | awk '{ printf "%-15s %-30s %-30s\n", "WARNING:", $1, "Role Not Defined" }' |tee -a $CONNECTIVITY_WARNING
fi


##########################################
# Analportal
FQDN=`floodenv whoHasRole -f anlportal`
##########################################
if [ $FQDN ]; then

   ##########################################
   # Verify Connectivity to Anlportal
   PORT=22
   ##########################################

   telnet $FQDN $PORT 1>$VERIFY_SOCKET 2>&1&
   sleep 1
   kill -9 $! 1>/dev/null 2>&1

   if grep 'Connect.* to' $VERIFY_SOCKET 1>/dev/null 2>&1; then
      echo $FQDN | awk '{ printf "%-15s %-30s %-30s %-20s\n", "INFO:", $1, "Anlportal (PORT 22)", "SOCKET UP" }' >> $CONNECTIVITY_INFO
      su flood -c "ssh -i ~flood/.ssh/batch_remote floodxfr@flanlport200 hostname" > $VERIFY_CONNECTION
      if [ $? -ne 0 ]; then
         echo $FQDN | awk '{ printf "%-15s %-30s %-30s %-20s\n", "CRITICAL:", $1, "Anlportal (PORT 22)", "NO SSH CONNECTIVITY" }' |tee -a $CONNECTIVITY
      else
         echo $FQDN | awk '{ printf "%-15s %-30s %-30s %-20s\n", "INFO:", $1, "Anlportal (PORT 22)", "SSH CONNECTIVITY OK" }' >> $CONNECTIVITY_INFO
      fi
   else
      echo $FQDN | awk '{ printf "%-15s %-30s %-30s %-20s\n", "CRITICAL:", $1, "Anlportal (PORT 22)", "SOCKET DOWN" }' |tee -a $CONNECTIVITY
   fi

else
   echo ANLPORTAL | awk '{ printf "%-15s %-30s %-30s\n", "WARNING:", $1, "Role Not Defined" }' |tee -a $CONNECTIVITY_WARNING
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
