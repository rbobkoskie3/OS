#!/bin/bash

# ID: rb868x 1029 Nov  1 18:42 Verify_PortScanner-Telnet.bash

# telnet-based TCP portscanner

# delay in seconds
DELAY=0.001

if [[ $# -ne 2 ]]
then
	echo "usage: $0 <mode> <host>"
	echo -e "modes:\t1 - common TCP ports only"
	echo -e "\t2 - all TCP ports"
	exit
fi

if [[ $1 -eq 1 ]]
then
	echo "scanning for the following common TCP ports on $2 ..."
	for port in `grep '/tcp' /etc/services | cut -d '/' -f 1 | cut -d ' ' -f 2 | grep -v '#' | awk '{print $2}' | sort | uniq`
	do
		echo -en "$port "
		if echo -en "open $2 $port\nlogout\quit" | telnet 2>/dev/null | grep 'Connected to' > /dev/null
		then	
			echo -en "\n\nport $port/tcp is open\n\n"
		fi
		sleep $DELAY
	done
	echo -en "\n"
elif [[ $1 -eq 2 ]]
then
	echo "scanning for all TCP ports on $2 ..."
	for((port=1;port<=65535;++port))
	do
		echo -en "$port "
		if echo -en "open $2 $port\nlogout\quit" | telnet 2>/dev/null | grep 'Connected to' > /dev/null
		then	
			echo -en "\n\nport $port/tcp is open\n\n"
		fi
		sleep $DELAY
	done
	echo -en "\n"
fi
