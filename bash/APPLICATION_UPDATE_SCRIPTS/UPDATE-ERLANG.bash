#! /bin/bash

ERLANG=`ls |grep erlang`

rpm -e $(rpm -qa | grep flood-torrent-fframework)
rpm -e $(rpm -qa | grep flood-torrent-pargsproxy)
rpm -e $(rpm -qa | grep flood-torrent-ffstatsmanager)
rpm -e $(rpm -qa | grep erlang-otp)

echo $ERLANG
rpm -ih $ERLANG
