# Configure apache2 
sed -i "s/\;default_charset/default_charset/g" /etc/php5/apache2/php.ini  

# if var WEB is set then no SSL site (in case you use a SSL proxy that terminates it)
# otherwise disable plain html
if [ -z $WEB ]  
  then 
    a2ensite default-ssl 
    a2enmod ssl  
    a2dissite 000-default
    sed -i "s/Listen\ 80/\#Listen 80/g" /etc/apache2/ports.conf
fi 

# Change max upload size and execution time
sed -i "s/upload_max_filesize\ \=\ 2M/upload_max_filesize\ \=\ 1024M/g" /etc/php5/apache2/php.ini
sed -i "s/post_max_size\ \=\ 8M/post_max_size\ \=\ 1048M/g" /etc/php5/apache2/php.ini
sed -i "s/max_execution_time\ \=\ 30/max_execution_time\ \=\ 300/g" /etc/php5/apache2/php.ini

# Moving owncloud to root of webserver
rm -rf /var/www/html
mv /var/www/owncloud /var/www/html

