# Configure apache2 
    sed -i "s/\;default_charset/default_charset/g" /etc/php5/apache2/php.ini  
    a2ensite default-ssl 
    a2enmod ssl  

# For phpmyadmin
ln -s /etc/phpmyadmin/apache.conf /etc/apache2/conf-available/phpmyadmin.conf
a2enconf phpmyadmin
php5enmod mcrypt
 
   # start Apache  
    /etc/init.d/apache2 start  
 
    rm /firstrun > /dev/null 2>&1 

