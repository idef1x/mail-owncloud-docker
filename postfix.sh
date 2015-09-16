#!/bin/bash
/etc/init.d/postfix start

# monitor master process
while true
do
  if ! `ps aux|grep master|grep -v grep>/dev/null`
    then exit 1
  fi
  # wait 30 seconds before recheck
  sleep 30
done

