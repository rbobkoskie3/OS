# $Id: common.bash 10815 2008-10-28 03:55:05Z hurley $

# Deployment settings.  Sourced by other deployment tools

# change these as appropriate
STAGER=rb868x              # person staging the release
# RELEASE=18.1.1              # number of the release being installed
RELEASE=`pwd |cut -d'/' -f6 |cut -d'-' -f2`
SMOPNUM=INSTALL-$RELEASE   # name of the directory under the STAGER's home:
                           # $STAGER/flood-releases/smops/$SMOPNUM
STAGER=${STAGER:?'Need to specify in common.bash the "STAGER" (name of the person staging the release)'}
RELEASE=${RELEASE:?'Need to specify in common.bash the release number'}

SCRIPT=$(basename $0)
MSGOUT=/tmp/SMOP-$SCRIPT-$(date +%Y%m%d).log
PKGLISTFILE=package.list   # list of the 3rd party packages that need to be installed
PKGRMVLISTFILE=package-remove.list   # list of packages that need to be removed
SETRELEASERPM=flood-torrent-setrelease-es5-8.2.1-13587.x86_64.rpm
#SETRELEASERPM=flood-torrent-setrelease-es4-1.7.1-9962.i686.rpm
SETRELEASEPKG=flood-torrent-setrelease-sol9-1.6.1-8456.pkg
#SETRELEASEPKG=flood-torrent-setrelease-sol10-3.1.1-11277.pkg

# set path variables
RELROOT=/flood-releases
STAGERHOME=$(grep $STAGER /etc/passwd |cut -d: -f6)
if [ -z "$STAGERHOME" ]; then    # if STAGER is not valid user
    echo "Can't determine STAGER's ($STAGER) home directory"
    exit
fi
LOCRELROOT=${STAGERHOME}/flood-releases
LOCBUNDLEDIR=$LOCRELROOT/smops/$SMOPNUM
LOCPKGDIR=$LOCBUNDLEDIR/rpms
RELSTAGEDIR=$RELROOT/$RELEASE/$SMOPNUM
PKGDIR=$RELROOT/rpms
WORKING=$RELSTAGEDIR/work
mkdir -p $WORKING
mkdir -p $PKGDIR
#MSGSOUT=$LOCBUNDLEDIR/${SMOPNUM}-install.MSGS
#rm -f $MSGSOUT

function message {
    # $1=message
    echo $1 >> $MSGOUT
    echo $1 1>&2
}

message "==================================="
message "STARTING:  $SCRIPT  ( $(date) ) "
message "==================================="
