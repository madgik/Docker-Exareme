#!/usr/bin/env bash

echo $( < /root/exareme/conf/master) > ./etc/exareme/master
./bin/exareme-admin.sh --start --local

if [[ -e "./var/log/exareme-master.log" ]]; then

    tail -f /tmp/exareme/var/log/exareme-master.log
else
    sleep 2;
    tail -f /tmp/exareme/var/log/exareme-worker.log
fi
