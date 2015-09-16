# Docker-VPSr
#
# VERSION               0.5

FROM      ubuntu:14.04
MAINTAINER idef1x <docker@sjomar.eu>

ENV DEBIAN_FRONTEND noninteractive

# create file to see if this is the firstrun when started
RUN touch /firstrun

RUN apt-get update && apt-get dist-upgrade -y 
RUN apt-get install -y wget 

RUN sh -c "echo 'deb http://download.opensuse.org/repositories/isv:/ownCloud:/community/xUbuntu_14.04/ /' >> /etc/apt/sources.list.d/owncloud.list"
RUN wget http://download.opensuse.org/repositories/isv:ownCloud:community/xUbuntu_14.04/Release.key
RUN apt-key add - < Release.key
RUN rm Release.key

# Set postfix to local mail delivery only for the moment. Actual config will take place at first run
RUN echo "postfix postfix/main_mailer_type select Local only" | debconf-set-selections

RUN apt-get update && apt-get install -yq\
	postfix postfix-mysql \
	fetchmail \
        dovecot-imapd dovecot-mysql dovecot-sieve dovecot-managesieved \
        spamassassin razor \
	owncloud \
	php5-imap \
	pwgen \
	supervisor 

COPY startup.sh /startup.sh
COPY *-setup.sh /
RUN chmod +x /startup.sh
COPY configs/postfix /etc/postfix
COPY configs/dovecot /etc/dovecot
COPY configs/spamassassin /etc/spamassasin
RUN wget http://sourceforge.net/projects/postfixadmin/files/latest/download?source=files -O /postfixadmin.tgz
RUN tar xf /postfixadmin.tgz 
RUN rm /postfixadmin.tgz
RUN mv postfixadmin* /var/www/postfixadmin
COPY configs/postfixadmin /var/www/postfixadmin
RUN chown -R www-data.www-data /var/www
RUN ln -s /etc/php5/mods-available/imap.ini /etc/php5/apache2/conf.d/20-imap.ini
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY postfix.sh /postfix.sh
COPY mysql.sh /mysql.sh

RUN chmod -x /etc/init.d/rsyslog


# Cleanup
RUN apt-get clean

EXPOSE 25 143 993 465 80 443 

ENTRYPOINT [ "/startup.sh" ]

