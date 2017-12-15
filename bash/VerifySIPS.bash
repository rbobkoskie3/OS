#! /bin/bash

# ID: rb868x 469 Jun 27 15:33 VerifySIPS.bash

# Will need a file of at least 60,000 unique IP Addresses named IP_LIST,
# use a random IP Address generator to create file, e.g., RAND-IP.bash
# Will also need a file with a single scansa record for use as a template --- SCANSA_TEMPLATE

for i in `cat IP_LIST`; do cat SCANSA_TEMPLATE |awk -F'|' '{ print $6 }' | while read f; do echo $f; echo $i; sed "s:$f:$i:g" <SCANSA_TEMPLATE >>test.scansa; done; done
