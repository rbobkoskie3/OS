#! /usr/bin/env bash

# Install the RPM (as root): 
rpm -ivh jre-6u16-linux-i586.rpm 

# Create symlinks: 
# mkdir -p /usr/local/java 
# cd /usr/local/java 
# ln -s /usr/java/jre1.6.0_16 jre 
mkdir -p /usr/local/java; cd /usr/local/java; ln -s /usr/java/jre1.6.0_16 jre; cd -
