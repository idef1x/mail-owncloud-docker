#!/bin/bash
if [ -f /firstrun ]
  then
    # Start syslog server to see something
    /etc/init.d/rsyslog start

    echo "Running for first time..need to configure..."

    source /mysql-setup.sh
    source /mail-setup.sh
    source /apache-setup.sh

    # clean up
    rm /*-setup.sh
    
  else
    # Start syslog server
    /etc/init.d/rsyslog start

    # start mysql server
    /etc/init.d/mysql start
    
    # start spamassassin daemon
    /etc/init.d/spamassassin start

    # start postfix,dovecot
    /etc/init.d/postfix start
    /usr/sbin/dovecot -F -c /etc/dovecot/dovecot.conf &

    # start Apache 
    /etc/init.d/apache2 start
fi

# to keep container alive keep this shell open:
tail -f /var/log/apache2/access.log

