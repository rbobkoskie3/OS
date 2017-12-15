#! /bin/bash

# ID: rb868x 670 Oct  2 20:10 replace_IP.bash

# Use an IP Address generator (generate_IP.bash) to create a file of unique IP Addresses named IP_LIST
# Will also need a file with a single syslog record for use as a template --- SYSLOG_TEMPLATE

# Function to Generate the IP_LIST using generate_IP.bash
GEN_IP() {
   ./generate_IP.bash >>IP_LIST
}

GEN_IP
# Generate the file (UNIQUE_IP) using the file (SYSLOG_TEMPLATE) for  the template --- with a unique IP Address for the fourth field
for i in `cat IP_LIST`; do cat SYSLOG_TEMPLATE |awk -F' ' '{ print $4 }' | while read f; do echo $f; echo $i; sed "s:$f:$i:g" <SYSLOG_TEMPLATE >>UNIQUE_IP; done; done
