#! /usr/bin/env bash

# Edit /etc/syslog.conf (RHEL 6.5, edit /etc/rsyslog.conf instead
# CAUTION: USE TABS TO SEPARATE FIELDS, NOT SPACES (except on RHEL 6.5)

cp -p /etc/rsyslog.conf /etc/rsyslog.conf_`echo $(date +%Y%m%d-%H%M%S)`.ORIG
cp -p /etc/rsyslog.conf /etc/rsyslog.conf.BACK
echo 'local0.emerg;local0.alert;local0.crit;local0.err;local0.warning;local0.notice;local0.info;local0.debug /var/flood/log/flood.log' >> /etc/rsyslog.conf.BACK
echo 'local0.emerg;local0.alert;local0.crit;local0.err;local0.warning;local0.notice;local0.info;local0.debug @loghost' >> /etc/rsyslog.conf.BACK
echo 'local0.emerg;local0.alert;local0.crit;local0.err;local0.warning;local0.notice;local0.info;local0.debug |/var/flood/dev/syslogfifo' >> /etc/rsyslog.conf.BACK

cp /etc/rsyslog.conf.BACK /etc/rsyslog.conf
rm /etc/rsyslog.conf.BACK

# Restart rsyslog:
/sbin/service rsyslog stop
/sbin/service rsyslog start
