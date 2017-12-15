#! /bin/bash

# ID: rb868x 702 Oct  2 20:03 Find_Replace_IP.bash

# Use a random IP Address generator (RAND-IP.bash) to create a file of unique IP Addresses named IP_LIST
# Will also need a file with a single pipe '|' delimited record for use as a template --- TEMPLATE

# Function to Generate the IP_LIST of length 100 using RAND-IP.bash
GEN_IP() {
   for (( i=0; i<100; i++ )); do ./RAND-IP.bash >>IP_LIST; done
}

GEN_IP
# Generate the file (UNIQUE_IP) using the file (TEMPLATE) for  the template --- with a unique IP Address for the sixth field
for i in `cat IP_LIST`; do cat TEMPLATE |awk -F'|' '{ print $6 }' | while read f; do echo $f; echo $i; sed "s:$f:$i:g" <TEMPLATE >>UNIQUE_IP; done; done
