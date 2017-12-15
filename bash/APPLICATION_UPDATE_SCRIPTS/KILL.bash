#! /bin/bash

ps -ef |grep flood
for x in `ps -ef | grep flood | grep -v grep | awk '{ print $2 }'`; do kill -9 ${x}; done
ps -ef |grep flood

