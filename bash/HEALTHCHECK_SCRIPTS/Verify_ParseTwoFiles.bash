#! /bin/bash

# ID: rb868x 9916 Dec 19 21:18 Verify_ParseTwoFiles.bash
# Tested on Solaris 10

clear

################################################
# Verify_ParseTwoFiles.bash will take two '|' pipe delimited
# data files as input, and parse selected fields, counting the
# number of fields that do not match. An output file will be
# generated showing the results  
################################################


################################################
# Assign Vars
#
# OFFSET will be used to 'cut' from pipe '|' dilimited
# field and up, e.g., field 17 and up are of interest
#
# FIELDS_FOR_COMPARE is an assignment associated with
# the  pipe '|' dilimited fields, e.g., the fields of interest
# NOTE --- FIELDS_FOR_COMPARE --- starts from the third field, as
# the first two fields in the data set are DESC and SESSION_ID respectively,
# and are used for info purposes only!
#
# OFFSET_COMPARE accounts for the FIELDS_FOR_COMPARE --- starting from the third field
# OFFSET_NARUS accounts for the non one-to-one mapping of header info, e.g.,
# the header info has two fields combined: ##Desc[01]=STRING(__LocalTimeStamp)
#
# PERCENT will be used to correlate percentage of ESSION_ID's common between two data files


OFFSET=17
FIELDS_FOR_COMPARE="3 4 5 6 7 8 9 10 11 12 13 14 15 16"
OFFSET_COMPARE=3
OFFSET_NARUS=1
PERCENT=25

SESSION_ID=/tmp/SESSION_ID_`echo $(date +%Y%m%d-%H%M%S)`
TMP_SESSION_ID=/tmp/TMP_SESSION_ID_`echo $(date +%Y%m%d-%H%M%S)`
TMP_SED=/tmp/TMP_SED_`echo $(date +%Y%m%d-%H%M%S)`

VERIFY_1=/tmp/VERIFY_1_`echo $(date +%Y%m%d-%H%M%S)`
VERIFY_2=/tmp/VERIFY_2_`echo $(date +%Y%m%d-%H%M%S)`
COMPARE_1=/tmp/COMPARE_1_`echo $(date +%Y%m%d-%H%M%S)`
COMPARE_2=/tmp/COMPARE_2_`echo $(date +%Y%m%d-%H%M%S)`

# Results output to this file 
DATA_DIFF=/tmp/DATA_DIFF_`echo $(date +%Y%m%d-%H%M%S)`
################################################


################################################
# Verify input data files

if [ $# -ne 2 ]; then
   echo "This script will compare data from two pipe '|' dilimited files"
   echo "Please input two pipe dilimited file to compare"
   exit 1
fi

# Verify input data files are pipe '|' dilimited files
if [[ ! `grep '|' \$1` ]]; then
   echo "Input file, $1 is not a '|' dilimited file"
   exit 2
fi

if [[ ! `grep '|' \$2` ]]; then
   echo "Input file, $2 is not a '|' dilimited file"
   exit 3
fi

# Quick check to Verify Input files are not identical, e.g., no diffs
if [[ ! `diff -s \$1 \$2` ]]; then
   echo "Input files, $1, $2 are identical"
   exit 4
fi

# Assign input files
DATA_INPUT_1=$1
DATA_INPUT_2=$2

# Due to large data set, Limit input data to a sub-set
# e.g., first HEAD num lines
HEAD=2000
DATA_1=/tmp/DATA_1_`echo $(date +%Y%m%d-%H%M%S)`
DATA_2=/tmp/DATA_2_`echo $(date +%Y%m%d-%H%M%S)`
head -$HEAD $DATA_INPUT_1 >$DATA_1
head -$HEAD $DATA_INPUT_2 >$DATA_2
################################################


################################################
# Verify root user
#if [ ! -w ~root ]; then
#   echo "\"$USER\" cannot execute this command...must be root.  Exiting..."
#   exit
#fi
################################################


################################################
# Obtain a list of unique SESSION_ID's, one per line

cat $DATA_1 | cut -d'|' -f3 > $TMP_SESSION_ID

# Clean the SESSION_ID file --- Remove all entries in file that do not start with a number: [^0-9]
echo "Obtaining a list of SESSION_ID's ..." 
sed '/^[^0-9].*$/d' <$TMP_SESSION_ID >$TMP_SED
cp $TMP_SED $TMP_SESSION_ID

# Clean the SESSION_ID file --- Remove all entries in file that are empty lines: ^$
echo "Removing empty lines from the list of SESSION_ID's ..."
sed '/^$/d' <$TMP_SESSION_ID >$TMP_SED
cp $TMP_SED $TMP_SESSION_ID

# Clean the SESSION_ID file --- Remove all duplicate entries in file
echo "Removing duplicate entries from the list of SESSION_ID's ..."
sort -u $TMP_SED >$SESSION_ID
################################################


################################################
# Verify number of common SESSION_ID's between two data files
# NOTE that since the SESSION_ID's were culled from the DATA_1,
# the compare will be against DATA_2

COUNT=0
for i in `cat $SESSION_ID`; do
   grep $i $DATA_2 1>/dev/null 2>&1
   if [ $? -eq 0 ]; then
      COUNT=`expr ${COUNT} + 1`
   fi
done

# Verify percent common SESSION_ID's between two data files, if < PERCENT, exit, e.g., no reason to run furtehr comparison
a=$COUNT
b=`cat $SESSION_ID |wc -l | sed -e 's/^[ \t]*//'`     # NOTE the SED comand will remove the whitespace preceeding the 'wc -l' command
c=`echo $a $b 100 | awk '{ printf int($1/$2*$3) }'`   # Use awk for INT division. SESSION_ID should never be 0

if [ $c -lt $PERCENT ]; then
   echo "EXITING ... Number of common SESSION_ID's between $DATA_1 $DATA_2: $a/$b=$c% is less than PERCENT=$PERCENT"

   # This exit is prior to the cleanup of files at the end of this script, so cleanup here
   rm $DATA_1 2>/dev/null
   rm $DATA_2 2>/dev/null
   rm $SESSION_ID 2>/dev/null
   rm $TMP_SESSION_ID 2>/dev/null
   rm $TMP_SED 2>/dev/null
   rm $COMPARE_1 2>/dev/null
   rm $COMPARE_2 2>/dev/null
   rm $VERIFY_1 2>/dev/null
   rm $VERIFY_2 2>/dev/null

   exit 5
else
   # Write result to output file
   echo "Number of common SESSION_ID's between $DATA_1 $DATA_2: $a/$b=$c%" >> $DATA_DIFF
fi
################################################


################################################
# PURGE files (older that one day) of the name /tmp/VERIFY_*, /tmp/DATA_DIFF_*

PURGE=/tmp/PURGE

FILE_NAME=VERIFY_*
find /tmp -name "$FILE_NAME" -type f -mtime +0 1>$PURGE 2>/dev/null
if [[ -s $PURGE ]]; then
   echo -e "\nThe following files were purged" >>$DATA_DIFF
   cat $PURGE >>$DATA_DIFF
   find /tmp -name "$FILE_NAME" -type f -mtime +0 -exec rm {} \; 1>/dev/null 2>&1
fi
cat /dev/null > $PURGE

FILE_NAME=DATA_DIFF_*
find /tmp -name "$FILE_NAME" -type f -mtime +0 1>$PURGE 2>/dev/null
if [[ -s $PURGE ]]; then
   echo -e "\nThe following files were purged" >>$DATA_DIFF
   cat $PURGE >>$DATA_DIFF
   find /tmp -name "$FILE_NAME" -type f -mtime +0 -exec rm {} \; 1>/dev/null 2>&1
fi
rm $PURGE 2>/dev/null
################################################


################################################
# Use the list if SESSION_ID's to cull pipe '|'
# dilimited fields from data files. NOTE that
# the var OFFSET will cut from field 17 and up
# , e.g., of interest

if [[ -s $SESSION_ID ]]; then
   echo "Removing the first $(($OFFSET-1)) fields from data files ..."
   #cat $SESSION_ID | while read i; do
   for i in `cat $SESSION_ID`; do
      # Cut from field $OFFSET to end of line in first data file, NOTE, carry fields 1, 3 (DESC, SESSION_ID) for info purposes
      `grep \$i \$DATA_1 | cut -d'|' -f1,3,$OFFSET- >> $VERIFY_1`
      # Cut from field $OFFSET to end of line in second data file, NOTE, carry fields 1, 3 (DESC, SESSION_ID) for info purposes
      `grep \$i \$DATA_2 | cut -d'|' -f1,3,$OFFSET- >> $VERIFY_2`
   done
else
   echo "Input file of SESSION_ID's is empty, and/or missing third pipe '|' dilimited field"
fi
################################################


################################################
# Compare fileds defined by $FIELDS_FOR_COMPARE

echo -e "Comparing fields \c"
for i in $FIELDS_FOR_COMPARE; do  echo -e "$(($i+$OFFSET-$OFFSET_COMPARE)) \c"; done
echo -e "\n"
echo "Data Diffs are written to $DATA_DIFF"

# Create headings for output table
echo -e "FIELD Desc[0] Desc[1] #DIFFS #COMPARE" | awk '{ printf "\n%-10s %-26s %-26s %-10s %-10s\n\n", $1, $2, $3, $4, $5 }' >> $DATA_DIFF

# Run loop to compare Data
for i in $FIELDS_FOR_COMPARE; do
   cat $VERIFY_1 |cut -d'|' -f$i >> $COMPARE_1
   cat $VERIFY_2 |cut -d'|' -f$i >> $COMPARE_2

   # Add data to 1st column of output file, e.g., the data for FIELD
   # NOTE, to get the correlated field placement w.r.t. the input data source,
   # add OFFSET and subtract OFFSET_COMPARE
   echo $(($i+$OFFSET-$OFFSET_COMPARE)) | awk '{ printf "%-11s", $1 }' >> $DATA_DIFF

   # Add data to 2nd and 3rd columns of output file, e.g., the data for DESC[0] DESC[1] respectively
   cat $DATA_INPUT_1 |grep \#\#Desc |cut -d',' -f$(($i+$OFFSET-$OFFSET_COMPARE-$OFFSET_NARUS)) | awk -F'\r' '{ printf "%-25s %-1s", $1, $2 }' >> $DATA_DIFF

   # Obtain diffs, e.g., Add data to 4th column of output file, e.g., the data for #DIFFS
   # NOTE that the egrep '\-|\+\+\+' looks for a single '-', this will effectively count the 
   # diffs, e.g., each diff WILL NOT be counted twice  
   diff -U 0 $COMPARE_1 $COMPARE_2 |egrep -v ^'@|\-|\+\+\+|No difference' |wc -l | awk '{ printf "%-11s", $1 }' >> $DATA_DIFF

   # Add data to the 5th column of output file, e.g., the data for #COMPARE 
   cat $VERIFY_1 |wc -l | awk '{ printf "%-10s\n", $1 }' >> $DATA_DIFF

   # Reset data for next iteration
   cat /dev/null > $COMPARE_1
   cat /dev/null > $COMPARE_2
done
################################################


rm $DATA_1 2>/dev/null
rm $DATA_2 2>/dev/null
rm $SESSION_ID 2>/dev/null
rm $TMP_SESSION_ID 2>/dev/null
rm $TMP_SED 2>/dev/null
rm $COMPARE_1 2>/dev/null
rm $COMPARE_2 2>/dev/null


################################################
# Give user choice to preserve Data that was used to compare fields.
# NOTE that this data contains the DESC and SESSION_ID fields
# which may be useful for troubleshooting/debugging 
#rm $VERIFY_1 2>/dev/null
#rm $VERIFY_2 2>/dev/null

while true; do
   read -p "Do you want to preserve the data used to compare fields ($VERIFY_1, $VERIFY_2) Yy/Nn: " YN
   echo $YN
   case $YN in
      [Yy]* )
             echo "Data files with DESC and SESSION_ID fields are saved: $VERIFY_1, $VERIFY_2";
      break;;
      [Nn]* )
             echo "Deleting files: $VERIFY_1, $VERIFY_2";
             rm $VERIFY_1 2>/dev/null
             rm $VERIFY_2 2>/dev/null
      break;;
      * ) echo "Please answer Yy/Nn: ";;
   esac
done
################################################

