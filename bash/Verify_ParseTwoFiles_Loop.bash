#! /bin/bash

# ID: rb868x 13296 Feb 10 19:04 Verify_ParseTwoFiles_Loop.bash
# Tested on Solaris 10, Red Hat 5.3

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
# OFFSET_NARUS accounts for the non one-to-one mapping of header info, e.g.,
# the header info has two fields combined: ##Desc[01]=STRING(__LocalTimeStamp)
#
# OFFSET_COMPARE accounts for the fields of interest, e.g.,
# starts from the third field, as the first two fields in the
# data set are DESC and SESSION_ID respectively,  and are
# used for info purposes only!
#
# PERCENT will be used to correlate percentage of ESSION_ID's common between two data files
#
# BOOL_SORT is used to allow data to be sorted:
   # If "TRUE" --- then sort according to '#DIFFS' as the key
   # else --- sort  according to 'FIELD' as the key

OFFSET=10
OFFSET_NARUS=1
OFFSET_COMPARE=3

PERCENT=5
BOOL_SORT="TRUE"

# Use $TIMESTAMP to uniquely identify files, thus
# allowing for for robust run time w/o race conditions
TIMESTAMP=`echo $(date +%Y%m%d-%H%M%S)`

SORT=/tmp/SORT-$TIMESTAMP
SORTED=/tmp/SORTED-$TIMESTAMP

SESSION_ID=/tmp/SESSION_ID-$TIMESTAMP
TMP_SESSION_ID=/tmp/TMP_SESSION_ID-$TIMESTAMP
TMP_SED=/tmp/TMP_SED-$TIMESTAMP

# Results output to this file
DATA_DIFF=/tmp/DATA_DIFF-$TIMESTAMP
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
# e.g., HEAD number lines to create a file
HEAD=2000
DATA_1=/tmp/DATA_1-$TIMESTAMP
DATA_2=/tmp/DATA_2-$TIMESTAMP
head -$HEAD $DATA_INPUT_1 >$DATA_1
head -$HEAD $DATA_INPUT_2 >$DATA_2
################################################


################################################
# Assign Data based on number of different vector types
#
# Based on input data (assume both files have same # vectors),
# Find number of data vectors, e.g., different descriptions, and
# create tmp data files accordingly, e.g., two sets of data files,
# corresponding to the two input files

NUMVECTOR=`grep "##Desc\[" $DATA_INPUT_1 |wc -l |sed -e 's/[\t ]//g;/^$/d'`

for (( n=0; n<$NUMVECTOR; n++ )); do

   touch /tmp/DESC_1$n-$TIMESTAMP
   touch /tmp/DESC_2$n-$TIMESTAMP

   touch /tmp/VERIFY_1$n-$TIMESTAMP
   touch /tmp/VERIFY_2$n-$TIMESTAMP

   touch /tmp/COMPARE_1$n-$TIMESTAMP
   touch /tmp/COMPARE_2$n-$TIMESTAMP

done
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
# SESSION_ID is the 3rd field in the pipe delimited
# data file. SESSION_ID was chosen because it is a
# unique identifier that is commmon to both data files

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
   rm $SORT 2>/dev/null
   rm $SORTED 2>/dev/null

   rm /tmp/DESC_*$TIMESTAMP 2>/dev/null
   rm /tmp/VERIFY_*$TIMESTAMP 2>/dev/null
   rm /tmp/COMPARE_*$TIMESTAMP 2>/dev/null

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

FILE_NAME=DATA_DIFF-*
find /tmp -name "$FILE_NAME" -type f -mtime +0 1>$PURGE 2>/dev/null
if [[ -s $PURGE ]]; then
   echo -e "\nThe following files were purged" >>$DATA_DIFF
   cat $PURGE >>$DATA_DIFF
   find /tmp -name "$FILE_NAME" -type f -mtime +0 -exec rm {} \; 1>/dev/null 2>&1
fi
rm $PURGE 2>/dev/null
################################################


################################################
# Create separate files containing DESC[*] data respectively

function createFileDesc() {

   # Grep for data based on DESC[*] and write file
   local numdataset=$1
   local numvector=$2

   local desc=`ls /tmp/DESC_$numdataset$numvector-$TIMESTAMP`
   local dataset=`ls /tmp/DATA_$numdataset-$TIMESTAMP`

   grep "^\[$numvector\]" $dataset > $desc

}

for (( n=0; n<$NUMVECTOR; n++ )); do
   # CALL createFileDesc for Data Set 1
   createFileDesc 1 $n &

   # CALL createFileDesc for Data Set 2
   createFileDesc 2 $n &

   wait
done
################################################


################################################
# Use the list if SESSION_ID's to cull pipe '|'
# dilimited fields from data files to create
# data files using the DESC[*] to use for compare.
# NOTE that the var OFFSET will cut from field 17
# and up , e.g., of interest.

function createFileVerify() {

   # Grep for data based on DESC[*] and write file
   local numdataset=$1
   local numvector=$2
   local id=$3
   local offset=$4

   local desc=`ls /tmp/DESC_$numdataset$numvector-$TIMESTAMP`
   local verify=`ls /tmp/VERIFY_$numdataset$numvector-$TIMESTAMP`

   grep $id $desc | cut -d'|' -f1,3,$offset- >> $verify

}

if [[ -s $SESSION_ID ]]; then
   echo "Removing the first $(($OFFSET-1)) fields from data files ..."

   for i in `cat $SESSION_ID`; do
      # Cut from field $OFFSET to end of line in first data file, NOTE, carry fields 1, 3 (DESC, SESSION_ID) for info purposes

      for (( n=0; n<$NUMVECTOR; n++ )); do
         # CALL createFileVerify for Data Set 1
         createFileVerify 1 $n $i $OFFSET &

         # CALL createFileVerify for Data Set 2
         createFileVerify 2 $n $i $OFFSET &

         wait
      done
   done
else
   echo "Input file of SESSION_ID's is empty, and/or missing third pipe '|' dilimited field"
fi
################################################


################################################
# Compare fileds defined by $FIELDS_FOR_COMPARE

echo -e "Comparing fields\n"
echo "Data Diffs are written to $DATA_DIFF"


function findDiffs() {

   # Create files to compare fields, and write file
   local inputdata1=$1
   local inputdata2=$2
   local numvector=$3
   local field=$4
   local offset=$5
   local offsetcompare=$6
   local offsetnarus=$7

   local verify1=`ls /tmp/VERIFY_$inputdata1$numvector-$TIMESTAMP`
   local verify2=`ls /tmp/VERIFY_$inputdata2$numvector-$TIMESTAMP`
   local compare1=`ls /tmp/COMPARE_$inputdata1$numvector-$TIMESTAMP`
   local compare2=`ls /tmp/COMPARE_$inputdata2$numvector-$TIMESTAMP`

   # Create files to compare for each field
   cat $verify1 |cut -d'|' -f$field >> $compare1
   cat $verify2 |cut -d'|' -f$field >> $compare2

   # Add data to 1st column of output file, e.g., the data for FIELD
   # NOTE, to get the correlated field placement w.r.t. the input data source,
   # add OFFSET and subtract OFFSET_COMPARE
   echo $(($field+$offset-$offsetcompare)) | awk '{ printf "%-11s", $1 }' >> $SORT

   # Add data to 2nd column of output file, e.g., the data for DESC[*]
   grep "^##Desc\[$numvector\]" $DATA_INPUT_1 |cut -d',' -f$(($field+$offset-$offsetcompare-$offsetnarus)) | awk -F'\r' '{ printf "%-29s", $1 }' >> $SORT

   # Obtain diffs, e.g., Add data to 3rd column of output file, e.g., the data for #DIFFS
   # NOTE that the egrep '\-|\+\+\+' looks for a single '-', this will effectively count the
   # diffs, e.g., each diff WILL NOT be counted twice
   diff -U 0 $compare1 $compare2 |egrep -v ^'@|\-|\+\+\+|No difference' |wc -l | awk '{ printf "%-11s", $1 }' >> $SORT

   # Add data to the 4th column of output file, e.g., the data for #COMPARE*
   local numcompares=`cat $compare2 |wc -l |sed -e 's/[\t ]//g;/^$/d'`
   echo $numcompares | awk '{ printf "%-10s\n", $1 }' >> $SORT

   # Reset data files to compare for next iteration
   cat /dev/null > $compare1
   cat /dev/null > $compare2

}

# Run loop to compare Data --- loop through DESC[*]
for (( n=0; n<$NUMVECTOR; n++ )); do

   # Create headings for output table
   echo -e "FIELD Desc[$n] #DIFFS #COMPARE" | awk '{ printf "\n%-10s %-28s %-10s %-10s\n\n", $1, $2, $3, $4 }' >> $DATA_DIFF

   # Clear the the file, e.g., 'cat /dev/null > $SORT'
   cat /dev/null > $SORT

   # The var $ENDFIELD is used as a terminating var for the iterative loop,
   # it is unique for each DESC[*]
   NUMFIELD=`grep "##Desc\[$n" $DATA_INPUT_1 | awk -F',' '{ print NF }'`
   ENDFIELD=$(($NUMFIELD + $OFFSET_NARUS + $OFFSET_COMPARE - $OFFSET))

   # Loop through delimited fields and compare
   for (( i=$OFFSET_COMPARE; i<=$ENDFIELD; i++ )); do
      # CALL findDiffs for Data Set 1
      findDiffs 1 2 $n $i $OFFSET $OFFSET_COMPARE $OFFSET_NARUS
   done

   # SORT the data for DESC[*]
   if [ $BOOL_SORT == TRUE ]; then
      echo "Sorting data for DESC[$n] using #DIFFS as the key"
      sort -r -nk3 $SORT -o $SORTED
      cat $SORTED >> $DATA_DIFF
   else
      echo "Sorting data for DESC[$n] using #FIELD as the key"
      cat $SORT >> $DATA_DIFF
   fi
done
################################################


rm $DATA_1 2>/dev/null
rm $DATA_2 2>/dev/null
rm $SESSION_ID 2>/dev/null
rm $TMP_SESSION_ID 2>/dev/null
rm $TMP_SED 2>/dev/null
rm $SORT 2>/dev/null
rm $SORTED 2>/dev/null

rm /tmp/DESC_*$TIMESTAMP 2>/dev/null
rm /tmp/COMPARE_*$TIMESTAMP 2>/dev/null


################################################
# Give user choice to preserve Data that was used to compare fields.
# NOTE that this data contains the DESC and SESSION_ID fields
# which may be useful for troubleshooting/debugging 

SAVE_DATA=/tmp/SAVE_DATA
cat /dev/null > $SAVE_DATA

for (( n=0; n<$NUMVECTOR; n++ )); do
   ls /tmp/VERIFY_1$n-$TIMESTAMP >> $SAVE_DATA
   ls /tmp/VERIFY_2$n-$TIMESTAMP >> $SAVE_DATA
done

while true; do
   read -p "Do you want to preserve the data used to compare fields (Yy/Nn): " YN
   echo $YN
   case $YN in
      [Yy]* )
             echo -e "Data files with DESC and SESSION_ID fields are saved: \n`cat $SAVE_DATA`";
      break;;
      [Nn]* )
             echo -e "Deleting files: \n`cat $SAVE_DATA`";
             for i in `cat $SAVE_DATA`; do rm $i 2>/dev/null; done
      break;;
      * ) echo "Please answer Yy/Nn: ";;
   esac
done

rm $SAVE_DATA 2>/dev/null
################################################

