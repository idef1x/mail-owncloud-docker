    # Configuring SSH server 
    if [ ! -d /var/run/sshd ]; then 
      mkdir /var/run/sshd 
      chmod 0755 /var/run/sshd 
    fi 
   
    if [ -z $SSHUSER ] ; then SSHUSER=ubuntu; fi 
    if [ -z $SSHPASSWORD ] ; then SSHPASSWORD=ubuntu; fi 
    echo "adding ssh user to system" 
    useradd -m $SSHUSER -G sudo 
    echo "$SSHUSER:$SSHPASSWORD" | chpasswd 
     
    # start sshd server 
    /etc/init.d/ssh start 

