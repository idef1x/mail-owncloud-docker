if [ -z $SQLHOST ]
  then echo "using local SQL server..going to initialize"
    SQLHOST="127.0.0.1"
    # Configuring Mysql server account 
    if [ -z $SQLPWD]  
      then SQLPWD=`pwgen -s 12 1` 
    fi 
 
    if [ -z $SQLUSR ] 
      then SQLUSR="sqladmin" 
    fi 
 
    # Start mysql server 
    /etc/init.d/mysql start 
    # Wait 3 seconds for mysql server to start 
    sleep 3 
    # Create user and allow all access to SQL servr 
    mysql -uroot -e "CREATE USER '${SQLUSR}'@'%' IDENTIFIED BY '$SQLPWD'" 
    mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO '${SQLUSR}'@'%' WITH GRANT OPTION" 
    echo "SQL user $SQLUSR with password $SQLPWD created..." 
fi
