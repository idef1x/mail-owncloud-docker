# Docker-VPSr
#
# VERSION               0.5

FROM      ubuntu:14.04
MAINTAINER idef1x <docker@sjomar.eu>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
  && apt-get dist-upgrade -y \ 
  && apt-get install -y wget

# Getting owncloud repo
RUN sh -c "echo 'deb http://download.owncloud.org/download/repositories/stable/Ubuntu_14.04/ /' >> /etc/apt/sources.list.d/owncloud.list" \
  && wget -nv https://download.owncloud.org/download/repositories/stable/Ubuntu_14.04/Release.key -O Release.key \
  && apt-key add - < Release.key \
  && rm Release.key

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

# get postfixadmin
RUN wget http://sourceforge.net/projects/postfixadmin/files/latest/download?source=files -O /postfixadmin.tgz \
  && tar xf /postfixadmin.tgz \
  && rm /postfixadmin.tgz \
  && mv postfixadmin* /var/www/postfixadmin

COPY *.sh /
RUN chmod +x /startup.sh
COPY configs/postfix /etc/postfix
COPY configs/dovecot /etc/dovecot
COPY configs/spamassassin /etc/spamassassin
COPY configs/apache2 /etc/apache2/sites-available
COPY configs/postfixadmin /var/www/postfixadmin
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN chown -R www-data.www-data /var/www
RUN ln -s /etc/php5/mods-available/imap.ini /etc/php5/apache2/conf.d/20-imap.ini

# make startup script know it's the first run and clean-up
RUN touch /firstrun \
   && apt-get clean

EXPOSE 25 143 993 465 80 443 

ENTRYPOINT [ "/startup.sh" ]

