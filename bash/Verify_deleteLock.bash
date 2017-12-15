#! /bin/bash

# ID: rb868x 1662 Dec 15 21:53 Verify_deleteLock.bash

clear

################################################
# Verify_deleteLock.bash will look for '*.L' files in
# /flood-db and if any are found, report as an
# 'ALARM'. This program will also query the user if
# the '*.L' files should be deleted. If yes, then
# the files are deleted and a record of the deleted
# files is created.
################################################


if [ ! -w ~root ]; then
   echo "\"$USER\" cannot execute this command...must be root.  Exiting..."
   exit 1
fi

LOCKF=/tmp/LOCKF
DEL_LOCKF=/tmp/DEL_LOCKF
rm $LOCKF 2>/dev/null
rm $DEL_LOCKF 2>/dev/null

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

   while true; do
      read -p "Do you want to delete all LOCK files Yy/Nn: " YN
      echo $YN
      case $YN in
         [Yy]* )
            echo "Deleting LOCK files, output tee to stdout and $DEL_LOCKF ...";
            for i in `cat $LOCKF |awk -F' ' '{ print $2 }'`; do
               echo "Deleting $i" |tee -a $DEL_LOCKF;
               rm $i;
            done;
         break;;
         [Nn]* )
            echo "Not Deleting LOCK files";
         break;;
         * ) echo "Please answer Yy/Nn: ";;
         esac
   done

else
   echo No LOCK files found |tee -a $LOCKF
fi

rm $TMP_LOCKF 2>/dev/null
