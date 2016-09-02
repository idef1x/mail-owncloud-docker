#!/bin/bash

if [ -f /firstrun ]
  then
    # remote syslog server to docker host
#    SYSLOG=`netstat -rn|grep ^0.0.0.0|awk '{print $2}'`
#    echo "*.*	@$SYSLOG" > /etc/rsyslog.d/50-default.conf

    # Start syslog server to see something
    /etc/init.d/rsyslog start

    echo "Running for first time..need to configure..."

    source /mysql-setup.sh
    source /mail-setup.sh
    source /apache-setup.sh

    # Stopping ALL services so data can be moved if needed
    /etc/init.d/apache2 stop
    /etc/init.d/postfix stop
    killall dovecot
    /etc/init.d/spamassassin stop
    /etc/init.d/mysql stop
    /etc/init.d/rsyslog stop

    # Moving data /data or not?
    if [ ! -d /data ]
      then 
        echo "No /data found so assuming you've set up your own persistent volumes (-v </<dir> or --volumes-from <data container> ) or don't want it "
      else
        BASE="/data"
        
        if `ls -A $BASE`
         then 
           echo "Clean install apparently"

	   # Put certs on one place
           mkdir $BASE/ssl $BASE/ssl/certs $BASE/ssl/keys
       
           # Moving data to data volume and symlinking them
           mv /var/lib/mysql $BASE/mysql
           ln -s $BASE/mysql /var/lib/mysql

           mv /var/www $BASE/www
           ln -s $BASE/www /var/www
           # Set ownership of www dir to www-data
           chown -R www-data.www-data $BASE/www
           
           # Move maildir
           mv /var/vmail $BASE/vmail
           ln -s $BASE/vmail /var/vmail
          
           # Move certs and keys
           mv /etc/ssl/certs/ssl-cert-snakeoil.pem $BASE/ssl/certs/ssl-$HOSTNAME.pem
           ln -s $BASE/ssl/certs/ssl-$HOSTNAME.pem /etc/ssl/certs/ssl-cert-snakeoil.pem
           mv /etc/ssl/private/ssl-cert-snakeoil.key $BASE/ssl/keys/ssl-$HOSTNAME.key
           ln -s $BASE/ssl/keys/ssl-$HOSTNAME.key /etc/ssl/private/ssl-cert-snakeoil.key
           mv /etc/dovecot/dovecot.pem $BASE/ssl/certs/
           ln -s $BASE/ssl/certs/dovecot.pem /etc/dovecot/dovecot.pem
           mv /etc/dovecot/private/dovecot.pem $BASE/ssl/keys/
           ln -s $BASE/ssl/keys/dovecot.pem /etc/dovecot/private/dovecot.pem

         else
           # for updated owncloud and postfixadmin mv them in right location and copy configs/data
           mv $BASE/www $BASE/www.old
           mv /var/www $BASE/www
           ln -s $BASE/www /var/www
	   # copying configs
           cp $BASE/www.old/html/config/config.php $BASE/www/html/config/config.php
           cp $BASE/www.old/postfixadmin/config.local.php $BASE/www/postfixadmin/config.local.php
           # moving owncloud data
           rm -rf $BASE/www/html/data
	   mv $BASE/www.old/html/data $BASE/www/html/data
           # also copy apps, since reenabling them whithout being installed yet will give a start update process 
           # for every app :(. You still have to reenable them though. but that's owncloud's thing
           cp -dpr $BASE/www.old/html/apps $BASE/www/html/
           # Set ownership of www dir to www-data
           chown -R www-data.www-data $BASE/www
           # clean-up old owncloud dir...
           rm -rf $BASE/www.old

           rm -rf /var/lib/mysql
           ln -s $BASE/mysql /var/lib/mysql
           rm -rf /var/vmail
           ln -s $BASE/vmail /var/vmail
           # certs
           rm /etc/ssl/certs/ssl-cert-snakeoil.pem 
           ln -s $BASE/ssl/certs/ssl-$HOSTNAME.pem /etc/ssl/certs/ssl-cert-snakeoil.pem
           rm /etc/ssl/private/ssl-cert-snakeoil.key 
           ln -s $BASE/ssl/keys/ssl-$HOSTNAME.key /etc/ssl/private/ssl-cert-snakeoil.key
           rm /etc/dovecot/dovecot.pem 
           ln -s $BASE/ssl/certs/dovecot.pem /etc/dovecot/dovecot.pem
           rm /etc/dovecot/private/dovecot.pem 
           ln -s $BASE/ssl/keys/dovecot.pem /etc/dovecot/private/dovecot.pem
      
        fi
    fi
    
    # clean up
    rm /*-setup.sh
    rm /firstrun

fi
    
# Sometimes with un unclean exit the rsyslog pid doesn't get removed and refuses to start
if [ -f /var/run/rsyslogd.pid ]
  then rm /var/run/rsyslogd.pid 
fi


# Start supervisor to start the services
/usr/bin/supervisord


