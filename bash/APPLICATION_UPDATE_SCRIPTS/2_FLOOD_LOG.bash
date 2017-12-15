#! /usr/bin/env bash

# Create the following named pipe:
mkdir -p /var/flood/dev
mknod /var/flood/dev/syslogfifo p

# Insure that /var/flood/dev/syslogfifo has permissions, 666:
chmod 755 /var/flood/dev
chmod 666 /var/flood/dev/syslogfifo

# Ensure that the file, /var/flood/log/flood.log exists,
# Create if necessary, and set owner, group and permissions as indicated:
mkdir -p /var/flood/log
chown flood /var/flood
chgrp flood /var/flood
chmod 755 /var/flood
chown floodshr /var/flood/log
chgrp floodshr /var/flood/log
chmod 775 /var/flood/log
touch /var/flood/log/flood.log
chown flood /var/flood/log/flood.log
chgrp floodshr /var/flood/log/flood.log
chmod 664 /var/flood/log/flood.log
