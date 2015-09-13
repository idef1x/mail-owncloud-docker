# Configure postfix /dovecot
if [ -z $SQLDB ]
  then SQLDB="mail"
fi
    
    # Create virtualhosts dir and user
    useradd -G mail -N -r -d /var/vmail -u 150 -m vmail
    chgrp -R mail /var/vmail
    chmod -R 770 /var/vmail
    chown -R vmail.mail /etc/dovecot
    # chown -R root.root /etc/postfix
    sed -i "s/ENABLED=0/ENABLED=1/g" /etc/default/spamassassin
    
    # Adapt configs to contain SQL password:
    sed -i "s/VAR_SQLPWD/$SQLPWD/g" /etc/postfix/*
    sed -i "s/VAR_SQLUSR/$SQLUSR/g" /etc/postfix/*
    sed -i "s/VAR_SQLHOST/$SQLHOST/g" /etc/postfix/*
    sed -i "s/VAR_SQLDB/$SQLDB/g" /etc/postfix/*

    sed -i "s/VAR_SQLPWD/$SQLPWD/g" /etc/dovecot/dovecot-sql.conf.ext
    sed -i "s/VAR_SQLUSR/$SQLUSR/g" /etc/dovecot/dovecot-sql.conf.ext
    sed -i "s/VAR_SQLHOST/$SQLHOST/g" /etc/dovecot/dovecot-sql.conf.ext
    sed -i "s/VAR_SQLDB/$SQLDB/g" /etc/dovecot/dovecot-sql.conf.ext

    sed -i "s/VAR_SQLPWD/$SQLPWD/g" /var/www/postfixadmin/config.local.php
    sed -i "s/VAR_SQLUSR/$SQLUSR/g" /var/www/postfixadmin/config.local.php
    sed -i "s/VAR_SQLHOST/$SQLHOST/g" /var/www/postfixadmin/config.local.php
    sed -i "s/VAR_SQLDB/$SQLDB/g" /var/www/postfixadmin/config.local.php

    # Create database mail and owncloud when SQLHOST is localhost (cause I have admin privileges then)
    if [ "$SQLHOST" == "127.0.0.1" ]
      then echo "creating database mail for postfix,dovecot and postfixadmin"
        mysql -u$SQLUSR -p$SQLPWD -e "create database mail"
# 	echo "creating database owncloud for owncloud"
#        mysql -u$SQLUSR -p$SQLPWD -e "create database owncloud"
    fi

    # Configure postfix
    hostname > /etc/mailname 
    postconf -e "myhostname = `cat /etc/hostname`" 
    postconf -e "mydestination = `cat /etc/hostname`" 
    postconf -e "inet_interfaces = all" 
    
    # configure postfixadmin 
    echo "Alias /postfixadmin /var/www/postfixadmin" > /etc/apache2/conf-available/postfixadmin.conf
    ln -s /etc/apache2/conf-available/postfixadmin.conf /etc/apache2/conf-available/postfixadmin.conf 
    a2enconf postfixadmin 
    # Set correct url for postafixadmin site, cause it originally shows a russian site
    #sed -i "s/postfixadmin\.com/postfixadmin\.sf\.net/g" /usr/share/postfixadmin/templates/footer.php
    # For default aliases set TLD to hostname`
    DOMAIN=`hostname -d`
    sed -i "s/change-this-to-your\.domain\.tld/$DOMAIN/g" /var/www/postfixadmin/config.inc.php

    # Create sieve-scripts dir cause it's not done automaticaly
    mkdir /var/vmail/sieve-scripts
    chown -R vmail.mail /var/vmail/sieve-scripts
 

