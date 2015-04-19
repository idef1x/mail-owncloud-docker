     
    # Configure postfix /dovecot
    
    # Create virtualhosts dir and user
    useradd -G mail -N -r -d /var/vmail -u 150 -m vmail
    chgrp -R mail /var/vmail
    chmod -R 770 /var/vmail
    chown -R vmail.mail /etc/dovecot
    # chown -R root.root /etc/postfix
    sed -i "s/ENABLED=0/ENABLED=1/g" /etc/default/spamassassin
    
    
    # create mysql database: 
    mysql -uroot -e "CREATE DATABASE mail" 
    mysql -uroot mail < /mail.sql
    rm /mail.sql

    # Adapt configs to contain SQL password:
    sed -i "s/VAR_SQLPWD/$SQLPASS/g" /etc/postfix/*
    sed -i "s/VAR_SQLPWD/$SQLPASS/g" /etc/dovecot/dovecot-sql.conf.ext
    sed -i "s/VAR_SQLPWD/$SQLPASS/g" /etc/postfixadmin/dbconfig.inc.php

    # Configure postfix
    hostname > /etc/mailname 
    postconf -e "myhostname = `cat /etc/hostname`" 
    postconf -e "mydestination = `cat /etc/hostname`" 
    postconf -e "inet_interfaces = all" 
    
    # start spam deamon
    /etc/init.d/spamassassin start
    # Start postfix 
    /etc/init.d/postfix start 
 
    # configure postfixadmin 
    ln -s /etc/postfixadmin/apache.conf /etc/apache2/conf-available/postfixadmin.conf 
    a2enconf postfixadmin 
    # Set correct url for postafixadmin site, cause it originally shows a russian site
    sed -i "s/postfixadmin\.com/postfixadmin\.sf\.net/g" /usr/share/postfixadmin/templates/footer.php

 
    # configure roundcube 
    sed -i "s/VAR_SQLPWD/$SQLPASS/g" /etc/roundcube/debian-db.php
    mysql -uroot -e "create database roundcube"
    mysql -uroot roundcube < /etc/roundcube/roundcube.sql

 
    # Start dovecot 
    /usr/sbin/dovecot -F -c /etc/dovecot/dovecot.conf & 

