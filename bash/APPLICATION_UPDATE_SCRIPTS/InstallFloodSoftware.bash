#! /usr/bin/env bash

if ((hostname | grep --quiet rpt) && (grep --quiet rpt    relbundles.list)) ||
   ((hostname | grep --quiet anl) && (grep --quiet anl    relbundles.list)) ||

   ((hostname | grep --quiet gr) && (grep --quiet grid    relbundles.list)) ||
   ((hostname | grep --quiet ft) && (grep --quiet ftp     relbundles.list)) ||

   ((hostname | grep --quiet faw) && (grep --quiet appweb relbundles.list)) ||
   ((hostname | grep --quiet db)  && (grep --quiet cache  relbundles.list));
then
  continue
else
  exit
fi

. common.bash       # sets some paths and other common variables
. relbundles.list   # sets release bundles: NEWBUNDLE and OLDBUNDLE

message "Installing FLOOD software"
message " Copying FLOOD bundles to $RELSTAGEDIR"
cp -f $LOCBUNDLEDIR/$NEWBUNDLE $RELSTAGEDIR
cp -f $LOCBUNDLEDIR/$OLDBUNDLE $RELSTAGEDIR

# unpack the new bundle in the working area
message " Copying bundle to $WORKING and unpacking"
cd $WORKING
rm $WORKING/flood-*.rpm    # remove rpms from previous binstall
cp -f ../$NEWBUNDLE $WORKING
tar zxvf $NEWBUNDLE   # extract

# install the software
message " Installing"
#/usr/local/bin/python2.6 binstall.py --force --update
/usr/local/bin/python2.7 binstall.py --force --update
#/usr/local/bin/python2.7 binstall.py -i
floodenv flover
