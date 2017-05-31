#!/bin/bash
if [ $1 = "uninstall" ]; then
    rm -rf /usr/bin/abf
    exit 0
fi
Select="0"
wdir=/usr/bin/abf
mkdir -p $wdir && cp -v lib/check.badlogin.sh $wdir/abf.sh
    if [ -f /etc/redhat-release ]; then
        sed -i 's/wlog=""/wlog=/var/log/secure/' $wdir/abf.sh
    fi

    if [ -f /etc/lsb-release ]; then
        sed -i 's/wlog=""/wlog=\/var\/log\/auth.log/' $wdir/abf.sh
    fi
sed -i 's|bcan=""|bcal='$wdir'|' $wdir/abf.sh

while [ $Select -lt 1 ]; do
    read -p "Do you want to get email notifications?[Yy/Nn]" noty
    case $noty in
        [Yy]* ) Select="2";;
        [Nn]* ) Select="3";;
    esac
   done
    if [ $Select = "2" ]; then
        read -p "Enter email for notifications:" mail
        sed -i 's/mail=""/mail='$mail'/' $wdir/abf.sh
    fi
chmod +x $wdir/abf.sh && $wdir/abf.sh
echo "Done."

