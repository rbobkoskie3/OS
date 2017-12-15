#! /usr/bin/env bash

# awk -F: '/flood/{print "USERADD -u",$3, "-g",$4, "-d",$6, "-s",$7, $1;next} /sis/{print "USERADD -u",$3, "-g",$4, "-d",$6, "-s",$7, $1;next}' /etc/passwd
# awk -F: '/flood/{print "GROUPADD -g",$3, $1;next} /sis/{print "GROUPADD -g",$3, $1;next}' /etc/group

groupadd -g 7826 fathom
groupadd -g 2001 metadata
groupadd -g 2207 lifeguard
useradd -c 'metadata' -g 2001 -u 2001 -s /bin/sh metadata
useradd -c 'fathom' -g 1 -u 7837 -s /bin/bash fathom

usermod -G floodxfr,floodcod,floodshr,lifeguard flood
usermod -G flood,floodcod,floodshr,floodxfr floodxfr
usermod -G flood,floodxfr,floodshr floodshr
usermod -G floodadm,floodcod floodcod
usermod -G floodadm floodadm
usermod -G flood metadata
