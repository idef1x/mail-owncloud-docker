# mail-owncloud-docker
**Contents:**
- postfix smtp mailserver with virtual domains/users and authentication
  via imap
- postfixadmin to administer email domains/mailboxes
- dovecot imap server
- dovecot sieve for filtering rules
- spamassassin for spam filtering
- roundcube webmail 
- owncloud for files and calendar/contacts sync
- mysql server to hold al mail and owncloud configurations/data

# Usage
docker run -P -d -h <FQDN of server> idef1x/mail-owncloud-docker

# Environment vars to use:
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

