#! /usr/bin/env bash

. common.bash

# RELEASE=20.1.2   # FOR PATCH
if [ `hostname` == 'mdtwnjitrpt01' ]; then BUNDLE='snocrptrh-es66*.gz'
elif [ `hostname` == 'mdtwnjitanl01' ]; then BUNDLE='snocanlrh-es66*.gz'

elif [[ $(hostname -s) = fvmitgr* ]]; then BUNDLE='snocgrid-es66*.gz'
elif [[ $(hostname -s) = fvmitft* ]]; then BUNDLE='snocftprh-es66*.gz'

elif [ `hostname` == 'mdtwnjitdb01' ]; then BUNDLE='snoccache-es66*.gz'
elif [ `hostname` == 'mdtwnjitfaw01' ]; then BUNDLE='snocappweb-es66*.gz'
fi

DIR=/flood-releases/$RELEASE/bundles

####################################################
# NOTE that $USER's identity file is required, e.g.,
# set up host keys for authenticated ssh/scp login
#scp -P 23712 -i ~rb868x/.ssh/id_rsa rb868x@10.5.200.140:$DIR/$BUNDLE . 1>$VERSION 2>&1

scp -P 23712 -i ~rb868x/.ssh/id_rsa rb868x@10.5.200.140:$DIR/$BUNDLE . 1>/dev/null 2>&1
####################################################

for i in `ls $BUNDLE`; do
   sed -e "s/^NEWBUNDLE=.*.gz$/NEWBUNDLE=$i/g" <relbundles.list >relbundles.list.NEW
   cp relbundles.list.NEW relbundles.list
   rm relbundles.list.NEW
done 
