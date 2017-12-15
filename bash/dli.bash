#! /bin/bash

# $Id: dli 4466 2005-08-26 20:02:46Z hurley $

SERVER=`uname -n`
TS=`date +%Y%m%d`
FILE=$SERVER.$TS.daytona-license-info
TMPFILE=/tmp/$FILE
OS=linux
ADDR=135.16.240.26

while [ ! -z "$1" ]
  do
  case "$1" in
      -f)    # send to file
      TOFILE=y
      exec > $TMPFILE
      ;;
      -s)    # solaris
      OS=solaris
      ;;
      -S)    # Send to staging server
      SEND='y'
      ;;
      -a)    # address
      shift
      ADDR=$1
      ;;
      -h|-?)    # help
      echo
      echo 'USAGE:  dli [-s] -a <address of staging server>'
      echo '   where -s indicates solaris'
      echo
      exit
      ;;
      *)
      break
      ;;
  esac
  shift
done

echo ==================================================  
echo Daytona licence information for server: $SERVER 
date  
echo ------------------------------------------------- 
echo 
echo "uname -a"  
echo 
uname -a 
echo ------------------------------------------------- 
echo "hostid"  
echo 
hostid 
echo ------------------------------------------------- 

if [ $OS = "linux" ] 
    then
    echo "cat /etc/issue"  
    echo 
    cat /etc/issue 
    echo ------------------------------------------------- 
    echo "cat /proc/cpuinfo"  
    echo 
    cat /proc/cpuinfo 
    echo ------------------------------------------------- 
    echo "cat /proc/meminfo"  
    echo 
    cat /proc/meminfo 
elif [ $OS = "solaris" ] 
    then
    echo "/usr/platform/sun4u/sbin/prtdiag"  
    echo 
    /usr/platform/sun4u/sbin/prtdiag  
fi

if [ "$TOFILE" = 'y' ]
then
    cat $TMPFILE 1>&2
    echo Output directed to file $TMPFILE  1>&2
    if [ "$SEND" = 'y' ] 
	then
	scp $TMPFILE $ADDR:$FILE
    fi
fi
