#! /usr/bin/env bash

# for i in tcp_wrappers-devel-7.6-57.el6.x86_64.rpm file-devel-5.04-21.el6.x86_64.rpm rpm-devel-4.8.0-47.el6.x86_64.rpm ksh-20120801-28.el6.x86_64.rpm; do rpm -ivh $i; done

if [ `hostname |grep fvmitgr` ]; then hostname;
   for x in `cat grd_install_3rdParty.txt`; do rpm -ivh $x; done
elif [ `hostname |grep fvmitft` ]; then hostname;
   for x in `cat ftp_install_3rdParty.txt`; do rpm -ivh $x; done
fi
