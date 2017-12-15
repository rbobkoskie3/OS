#! /usr/bin/env bash

# for i in `getent passwd |grep flood |cut -f1 -d':'`; do userdel $i; done

mkdir /users
useradd -u 2205 -g 2205 -d /users/sis -s /bin/sh sis
useradd -u 2101 -g 2101 -d /users/flood -s /bin/ksh flood
useradd -u 2105 -g 2105 -d /users/floodxfr -s /bin/bash floodxfr
useradd -u 2200 -g 2200 -d /users/floodcod -s /bin/sh floodcod
useradd -u 2202 -g 2202 -d /users/floodadm -s /bin/sh floodadm
useradd -u 2203 -g 2203 -d /users/floodanl -s /bin/sh floodanl
useradd -u 2204 -g 2204 -d /users/floodshr -s /bin/sh floodshr

useradd -u 268 -g 2206 -d /users/sgeadmin -s /bin/bash sgeadmin
useradd -u 2205 -g 2205 -d /users/sis -s /bin/sh sis
