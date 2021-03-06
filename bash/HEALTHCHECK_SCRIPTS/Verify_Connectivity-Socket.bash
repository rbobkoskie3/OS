#! /bin/bash

# ID: rb868x 2493 Dec 15 22:06 Verify_Connectivity-Socket.bash
# Tested on Solaris 10

clear

################################################
# Verify_Connectivity-Socket.bash checks for socket
# connectivity via telnet.
################################################


##########################################
# This command will work for a socket where the connectivity is up,
# however, it will 'hang' for a socket where the connectivity is down 
##########################################

#HOST=mtw-flood-dbc;for((port=9017;port<=9019;++port));do echo -en "$port ";if echo -en "open $HOST $port\nlogout\quit" | telnet 2>/dev/null | grep 'Connected to' > /dev/null;then echo -en "\n\nport $port/tcp is open\n\n";fi;done


##########################################
# Use telnet and grep for 'Connect.* to'
# to verify socket, need to 'echo quit' to
# close the connection, this also closes
# a 'hanging' telnet, e.g., a telnet attempt
# to a socket where connectivity is down 
##########################################

VERIFY_SOCKET=/tmp/VERIFY_SOCKET

SOCKET="flanlport200:22 fathom.itl.cso.att.com:9019 fldig01:9017 mtw-flood-isc:50110 mtw-flood-dbc:9017 mtw-flood-dbc:22 mtw-flood-asc:50025"
for i in $SOCKET; do
   SERVER=`echo $i |cut -d: -f1`
   PORT=`echo $i |cut -d: -f2`

   telnet $SERVER $PORT 1>$VERIFY_SOCKET 2>&1&
   sleep 1
   kill -9 $! 1>/dev/null 2>&1

   if grep 'Connect.* to' $VERIFY_SOCKET 1>/dev/null 2>&1; then
      echo $? $SERVER:$PORT == UP 
   else
      echo $? $SERVER:$PORT == DOWN 
   fi

done

rm $VERIFY_SOCKET 1>/dev/null 2>&1


##########################################
# Use netstat to verify --- this is clumsy, e.g., a server
# can connect to more than one server on the same port
# grepping for ESTABLISHED is alos clumsy, as the connection
# closes before the grep completes, e.g., the test fails most
# of the time when grepping for ESTABLISHED
##########################################

## Resolve IP --- /etc/hosts, IT env.
#IP=`grep $FQDN /etc/hosts |awk -F' ' '{ printf $1 }'`
#if [ $? -ne 0 ]; then
   ## Resolve IP --- LDAP, ST, Prod env.
   #IP=`getent hosts $FQDN |awk -F' ' '{ printf $1 }'`
#fi


#telnet $SERVER $PORT 1>/dev/null 2>&1&
#netstat -an |grep $IP |grep $PORT 1>/dev/null 2>&1
#netstat -an |grep $IP |grep $PORT |grep ESTABLISHED 1>/dev/null 2>&1

#if grep "Connect.* to" $TMP; then
#if [ $? -eq 0 ]; then
#   echo $? --- 0 == SUCCESS
#else
#   echo $? --- !0 == FAIL
#fi

#kill -9 $! 1>/dev/null 2>&1
