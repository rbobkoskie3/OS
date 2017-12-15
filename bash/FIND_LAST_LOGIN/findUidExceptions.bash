#!/usr/bin/env bash

############################################
# rb868x 548 Sep  4 21:52 findUidExceptions.bash
# Verified on RedHat 5.8
#
# findUidExceptions.bash removes excepted ATT UIDs from the list of ATT UIDs to be deleted
############################################


# lastlog -u <USER id>
# last -1 <USER id>

# Remove ATT UIDs from ATTUID_EXCEPTIONS file from the list of ATT UIDs to be deleted
cat ATTUID_EXCEPTIONS |while read i; do
   sed -i "/$i/d" ACCOUNT
done

for i in `cat ACCOUNT`; do lastlog -u  $i |grep -v Username; done
