#! /bin/bash

# ID: rb868x 900 Dec 15 21:50 Verify_Lock.bash

clear

################################################
# Verify_Lock.bash will look for '*.L' files in
# /flood-db and if any are found, report as an
# 'ALARM'.
################################################


if [ ! -w ~root ]; then
   echo "\"$USER\" cannot execute this command...must be root.  Exiting..."
   exit 1
fi

LOCKF=/tmp/LOCKF
rm $LOCKF 2>/dev/null

SEARCH_FOR_LOCK=/flood-db
TMP_LOCKF=/tmp/TMP_LOCKF


echo "Looking for LOCK files in $SEARCH_FOR_LOCK, output tee to stdout and $LOCKF"
for i in `find $SEARCH_FOR_LOCK -name '*.L'`; do
   echo $i >> $TMP_LOCKF
done

if [[ -s $TMP_LOCKF ]]; then
   for i in `cat $TMP_LOCKF`; do
      ls $i 1>/dev/null 2>&1
      if [ $? -eq 0 ]; then
         echo WARNING: $i |tee -a $LOCKF
      fi
   done
else
   echo No LOCK files found |tee -a $LOCKF
fi

rm $TMP_LOCKF 2>/dev/null
