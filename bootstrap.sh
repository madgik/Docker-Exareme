#!/usr/bin/env bash

echo $(hostname --ip-address) > ./etc/exareme/master
./bin/exareme-admin.sh --start --local

if [[ -e "./var/log/exareme-master.log" ]]; then

    tail -f ./var/log/exareme-master.log
else
    sleep 2;
    tail -f ./var/log/exareme-master.log
fi
