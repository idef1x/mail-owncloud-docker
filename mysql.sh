#!/bin/bash

# only start mysql if SQLHOST=127.0.0.1

# after first start for local mysql SQLHOST is not set anymore so put it back since otherwise for local mysql it won't work
# anymore
if [ -z $SQLHOST ]
  then SQLHOST="127.0.0.1"
fi

if [ "$SQLHOST" == "127.0.0.1" ]
  then /etc/init.d/mysql start
fi

# Stay active for 5 seconds so supervisor thinks it was started ok
sleep 5

