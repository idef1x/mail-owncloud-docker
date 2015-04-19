# docker-VPS
This is my own VPS setup wich consists of:
- postfix smtp mailserver
- dovecot imap mail server
- owncloud for files and calendar/contacts sync
- mysql server to hold al mail and owncloud configurations/data
- openssh-server to be able to connect remotely to peek around ;-)

**Usage:** docker run -P -d -h <FQDN of server> idef1x/docker-mail-owncloud

# Environment vars to use:
- SSHUSER = ssh user to create (default ubuntu)
- SSHPASSWORD = ssh user pwd (default (ubuntu)
- SQLUSR = mysql admin user (default admin)
- SQLPASS = mysql user password (default random generated -> see logs for the password (docker logs <container ID>

# Postfixadmin
Default user/pwd: admin@example.com/postfix

Please create you own superadmin for the domains and so you can delete the default


# To Do:
- Apache certificates
- dovecot/postfix certificates
- dovecot-sieve not working yet
- Roundcube: add carddav support to integrate with owncloud
- Roundcube: sieve plugin not working yet (see dovecot-sieve ;) )

