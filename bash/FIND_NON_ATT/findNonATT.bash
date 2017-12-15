#! /usr/bin/env bash

# ID: rb868x 2025 Jun 21 10:51 findNonATT.bash
# Tested on Red Hat 5.3, Solaris 10


. common.VerifyUserAccount.bash

# ========================================
if [[ $# != 1 ]]; then
   echo -e "\nUSAGE: ./findOffshore.bash [suits.dat|osuits.dat]\n"
   exit 0
fi
FILE=$1

ATTUID="[a-zA-Z][a-zA-Z][0-9][0-9][0-9][a-zA-Z0-9]"

OS=`uname -s`
if [ `echo $OS |grep -i linux` ]; then
   EGREP="egrep -q"
   # REGEX ONLY WORKS FOR LINUX: ATTUID="[a-zA-Z]{2}[0-9]{3}[a-zA-Z0-9]"
   # AWK=awk -v n=1 -v s="TEST" 'NR == n {print s} {print}' $OUTPUT_NOMATCH_ATTUID >$TMP
   # SED=sed -i -e '1iTEST\' $OUTPUT_NOMATCH_ATTUID
   # SED=sed -e '1iTEST\' <$OUTPUT_NOMATCH_ATTUID >$TMP
   # SED=sed '1 i\TEST' <$OUTPUT_NOMATCH_ATTUID >$TMP
else # Solaris
   EGREP="egrep -s"
fi
# ========================================



if [[ $FILE == "suits.dat" ]]; then
   echo -e "\n$FILE: Checking for User Accounts conforming to ATTUID that \nare are associated with employees who have left ATT, \ne.g., no longer listed in the Webphone DB"
   for i in `getent passwd |cut -d':' -f1`; do
      # LINUX ONLY, PROGRAM WILL NOT RUN IN SOLARIS
      # IF THIS LINE IS NOT COMMENTED OUT:
      # if [[ $i =~ $ATTUID ]]; then

      # Check for User Accounts conforming to ATTUID that are
      # are associated with employees who have left ATT, e.g.,
      # no longer listed in the Webphone DB
      if echo $i | $EGREP $ATTUID; then
         if ! $EGREP $i $FILE; then 
            echo $i >> $OUTPUT_SUITS_ATTUID
         fi
      fi
   done

elif [[ $FILE == "osuits.dat" ]]; then
   echo -e "\n$FILE: Checking for Revoked ATTUIDs dating back to December 2001"
   for i in `getent passwd |cut -d':' -f1`; do
      # LINUX ONLY, PROGRAM WILL NOT RUN IN SOLARIS
      # IF THIS LINE IS NOT COMMENTED OUT:
      # if [[ $i =~ $ATTUID ]]; then

      # Check for Revoked ATTUIDs dating back to December 2001
      if echo $i | $EGREP $ATTUID; then
         egrep $i $FILE |cut -d'|' -f1 >> $OUTPUT_OSUITS_ATTUID
      fi
   done
fi
