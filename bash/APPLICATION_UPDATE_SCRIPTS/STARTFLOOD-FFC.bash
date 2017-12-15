#! /bin/bash

# $Id: STARTFLOOD.bash 9173 2008-01-21 23:58:22Z hurley $

SCRIPT=$(basename $0)
MSGOUT=/tmp/SMOP-$SCRIPT-$(date +%Y%m%d).log
function message {
    # $1=message
    echo $1 >> $MSGOUT
    echo $1 1>&2
}

message "------------------------------ $(date)"

if [ ! -w ~root ]; then
    message "\"$USER\" cannot execute this command...must be root.  Exiting..."
    exit 1
fi

message "Starting flood"
floodenv ffc start
