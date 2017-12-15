#! /bin/bash

# Tested on Solaris 10

################################################
# VerifyCircularSimLink.bash finds and deletes
# Circular Symbolic Links in $PATH(S) provided
# as a var in this script. Output is logged to
# a file in /tmp, where, depending on conditions,
# logged with teh following alarms:
# [WARNING INFO].
################################################


############################################
CIRC_SYM_LINK_1=/tmp/CIRC_SYM_LINK_1
CIRC_SYM_LINK_2=/tmp/CIRC_SYM_LINK_2
LOG_RESULTS=/tmp/LOG_RESULTS

DIRS='/opt/sims /opt/sis /usr/local/lib/python2.5/site-packages'
############################################


# Delete output file prior to each run
rm $LOG_RESULTS 2>/dev/null


############################################
function findCircSymLnk() {

   local searchPath=$1
   local logResults=$2


   find $searchPath -type l -follow 2> $CIRC_SYM_LINK_1

   if [[ -s $CIRC_SYM_LINK_1 ]]; then

      # Cut $searchPath from the circular symlink vars and eliminate the last '/'
      cat $CIRC_SYM_LINK_1 |while read i; do echo $i |cut -d ' ' -f5 |sed s:/$:: >>$CIRC_SYM_LINK_2; done

      for i in `cat $CIRC_SYM_LINK_2`; do
         rm $i 1>/dev/null 2>&1

         if [ $? -ne 0 ]; then
            # Capture last directory
            #echo ${i##*/}
            echo "INFO: $i, was not able to be removed" |tee -a $logResults
         else
            echo "WARNING: $i, was removed" |tee -a $logResults
         fi
      done

      cat /dev/null > $CIRC_SYM_LINK_1
      cat /dev/null > $CIRC_SYM_LINK_2

   else
      echo -e "INFO: No Circular Simlinks found in $searchPath" |tee -a $logResults
   fi
}
############################################


############################################
clear
echo -e "Running ... Log Results written to $LOG_RESULTS"
for SEARCH in $DIRS; do

   # Look for circular symlinks in $SEARCH
   echo -e "\nLooking for Circular Simlinks in: $SEARCH" |tee -a $LOG_RESULTS
   findCircSymLnk $SEARCH $LOG_RESULTS

done
############################################


rm $CIRC_SYM_LINK_1 2>/dev/null
rm $CIRC_SYM_LINK_2 2>/dev/null
