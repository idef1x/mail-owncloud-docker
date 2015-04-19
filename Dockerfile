# Docker-VPSr
#
# VERSION               0.1

FROM      ubuntu:14.04
MAINTAINER idef1x <docker@sjomar.eu>

ENV DEBIAN_FRONTEND noninteractive

# create file to see if this is the firstrun when started
RUN touch /firstrun

RUN apt-get update && apt-get install -y \
	wget

RUN sh -c "echo 'deb http://download.opensuse.org/repositories/isv:/ownCloud:/community/xUbuntu_14.04/ /' >> /etc/apt/sources.list.d/owncloud.list"
RUN wget http://download.opensuse.org/repositories/isv:ownCloud:community/xUbuntu_14.04/Release.key
RUN apt-key add - < Release.key
RUN rm Release.key

# Set postfix to local mail delivery only for the moment. Actual config will take place at first run
RUN echo "postfix postfix/main_mailer_type select Local only" | debconf-set-selections

RUN apt-get update && apt-get install -yq\
        dovecot-imapd dovecot-mysql dovecot-sieve \
	mcrypt \
	owncloud \
	php5-imap \
	phpmyadmin \
	postfix postfix-mysql postfixadmin \
	pwgen \
	roundcube roundcube-mysql roundcube-plugins roundcube-plugins-extra \
        spamassassin razor

ADD startup.sh /startup.sh
ADD *-setup.sh /
RUN chmod +x /startup.sh
ADD configs/mail.sql /mail.sql
COPY configs/postfix /etc/postfix
COPY configs/dovecot /etc/dovecot
COPY configs/spamassassin /etc/spamassasin
COPY configs/postfixadmin /etc/postfixadmin
COPY configs/roundcube /etc/roundcube
RUN chmod a+r /etc/roundcube/*

# Cleanup
RUN apt-get clean

EXPOSE 25 143 993 465 443

ENTRYPOINT [ "/startup.sh" ]

