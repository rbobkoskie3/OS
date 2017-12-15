#!/usr/bin/env bash

############################################
# rb868x 1294 Sep 12 19:29 findLastLogin.bash
# Verified on RedHat 5.8
#
# findLastLogin.bash finds user accounts that conform to the ATT UID syntax
# and identifies accounts that have not been logged into for a time determined by
# the variable LASTLOG
############################################


# lastlog -u <USER id>
# last -1 <USER id>
# The following one liner will find a user's last login, and if they never logged in to a server
# It has been verified on RH5.8 and Solaris 10
# for i in `getent passwd |cut -d ':' -f1 |grep [a-zA-Z][a-zA-Z][0-9][0-9][0-9][a-zA-Z0-9]`; do last -1 $i |grep $i; if [ $? -eq 1 ]; then echo $i NEVER LOGGED IN; fi; done


rm ATTUID ATTUID_KEEP 2>/dev/null
############################################
LASTLOG=90   #lastlog records more recent than DAYS
ATTUID='[a-zA-Z][a-zA-Z][0-9][0-9][0-9][a-zA-Z0-9]'
getent passwd |grep $ATTUID |cut -d':' -f1 > ACCOUNT
lastlog -t $LASTLOG |grep $ATTUID |awk '{ print $1 }' > ACCOUNT_KEEP
############################################

# Remove ATT UIDs from ACCOUNT_KEEP file from the list of ATT UIDs to be deleted
cat ACCOUNT_KEEP |while read i; do
   sed -i "/$i/d" ACCOUNT
done

for i in `cat ACCOUNT`; do lastlog -u  $i |grep -v Username; done
