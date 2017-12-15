#! /usr/bin/env bash

###############################
# NOTE: Verify grids, ftp and rpt are resolvable,
# /etc/hosts, or nslookup
###############################

dir=/gridware/sge

######################
mkdir -p $dir/default/
chown -R sgeadmin:sgeadmin /gridware/*
chmod -R 755 /gridware/*
######################


######################
grep sge_qmaster /etc/services
if [ $? -ne 0 ]; then echo '  *** ERROR: MODIFY /etc/services'; fi
grep sge_execd /etc/services
if [ $? -ne 0 ]; then echo '  *** ERROR: MODIFY /etc/services'; fi
######################


######################
# cp and untar gridware

cp n1ge-6_*.gz $dir
tar -C $dir -xzvf $dir/n1ge-6_0u4-bin-linux24-x64.tar.gz
tar -C $dir -xzvf $dir/n1ge-6_0u4-common.tar.gz
rm -f $dir/n1ge-6_*.gz
######################


######################
# Install gridware exec host

cd $dir
# ./install_execd
cd -
######################


######################
# Create symlink to common

ln -s /gridware/oge/default/common /gridware/sge/default/common
ls -l /gridware/sge/default/common
ls -lL /gridware/sge/default/common
######################

