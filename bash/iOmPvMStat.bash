#! /usr/bin/env bash

# rb868x 638 Jan 20 16:26 iOmPvMStat.bash


LOGFILE="/tmp/io_vm_mp_stat_`hostname`.log"

sar >$LOGFILE
echo -e "\n\n" >>$LOGFILE
while true; do 

   echo "################################" >>$LOGFILE
   echo `date +%Y' '%m/%d' '%H:%M:%S` >>$LOGFILE
   echo "################################" >>$LOGFILE

   echo -e '\n##### iostat #####' >>$LOGFILE
   iostat -xt >>$LOGFILE

   echo -e '\n##### vmstat #####' >>$LOGFILE
   vmstat -S M >>$LOGFILE
   vmstat -a -S M >>$LOGFILE
   vmstat -d -S M >>$LOGFILE

   echo -e '\n##### mpstat #####' >>$LOGFILE
   mpstat -P ALL >>$LOGFILE

   echo >>$LOGFILE
   sleep 60
done

