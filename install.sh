#!/bin/bash

read -p "Enter email for notifications:" mail
wdir=/usr/bin/abf
mkdir -p $wdir && cp -v lib/check.badlogin.sh $wdir/abf.sh
    if [ -f /etc/redhat-release ]; then
        sed -i 's/wlog=""/wlog=/var/log/secure/' $wdir/abf.sh
    fi

    if [ -f /etc/lsb-release ]; then
        sed -i 's/wlog=""/wlog=\/var\/log\/auth.log/' $wdir/abf.sh
    fi
sed -i 's|bcan=""|bcal='$wdir'|' $wdir/abf.sh
sed -i 's/mail=""/mail='$mail'/' $wdir/abf.sh
chmod +x $wdir/abf.sh && $wdir/abf.sh

echo "2"
