#!/bin/bash
#
# Script to generate unique IP addresses of the form 192.168.[0-255].[0-255]

INIT_IP="192.168.0.0"

function gen-ip() {

   local octet1=$1

   for i in {0..256}; do
      MOD=$(($i%256))
      if [[ $MOD -ne 0 ]]; then
         IP="192.168.$octet1.$MOD"
         echo $IP
      fi
   done
}


echo $INIT_IP
for i in {0..256}; do
   MOD=$(($i%256))
   if [[ $MOD -ne 0 ]]; then
      gen-ip $MOD
   fi
done
