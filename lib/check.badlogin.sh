#!/bin/bash


#Anti-BruteForce for Centos Made By Kirill Kamaldinov

############for Centos change wlog to /var/log/secure############
#working log#
wlog=""

###Working Directory [PWD]
bcan=""

###Email address to send notification to 
mail=""

#BasicFunctions[creates if not existing]
iffun(){
    if [ ! -f $1 ]; then
        touch $1
    fi
}
iffundir(){
    if [ ! -d $1 ]; then
        mkdir -p $1
    fi
}
iffun "$bcan/checker.art"
echo "-- $(date +%Y-%m-%d:%H:%M:%S) --" >> $bcan/checker.art

##how many bad logins
howman=$(cat /var/log/auth.log | egrep "Fail|fail" | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' |sort | uniq -c | sort -n |tail -1 | awk '{print $1}')
if [ $? = "0" ]; then 
	echo "howman - OK" >> $bcan/checker.art; else "howman - error!" >> $bcan/checker.art
fi

##problematic IP address
whois=$(cat /var/log/auth.log | egrep "Fail|fail" | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' |sort | uniq -c | sort -n |tail -1 | awk '{print $2}')

if [ $? = "0" ]; then 
        echo "whois - OK" >> $bcan/checker.art; else "whois - error!" >> $bcan/checker.art
fi
##how many bad logins before block
if [[ $howman -gt 7 ]]; then
		iffun "$bcan/whoisip.art"
   		wrz=$(cat $bcan/whoisip.art)
			if [[ $whois != $wrz ]]; then
			curl -s ipinfo.io/"$whois"/region > $bcan/gregion.art
		        	if [ $? = "0" ]; then
                			echo "1st Location checker - OK" >> $bcan/checker.art; else "1st Location checker - ERROR" >> $bcan/checker.art
        			fi	
				iffun "$bcan/gregion.art"
                iffun "$bcan/gcountry.art"
			sleep 0.5
			curl -s ipinfo.io/"$whois"/country > $bcan/gcountry.art
			if [ $? = "0" ]; then
                                        echo "2nd Location checker - OK" >> $bcan/checker.art; else "2nd Location checker - ERROR" >> $bcan/checker.art
                                fi
			sleep 0.5
			##region
			gregion=$(cat $bcan/gregion.art)
			##country
			gcountry=$(cat $bcan/gcountry.art)
			/sbin/iptables -I INPUT -s $whois -j DROP
				        if [ $? = "0" ]; then
                				echo "IPTABLES - OK" >> $bcan/checker.art; else "CRITICAL! - CHECK IPTABLES!" >> $bcan/checker.art
				        fi
			    iffun "/var/log/chkbl.log"
			echo "$(date +%Y-%m-%d:%H:%M:%S) -  ApresMainHost - IP: $whois - $gregion , $gcountry  were blocked after $howman bad logins." >> /var/log/chkbl.log
#			echo "--ANTI BruteForce-- IP: $whois - $gregion , $gcountry  were blocked after $howman bad logins." | /usr/sbin/sendmail -F ANTI-DDOS $mail
			iffun "$bacn/noty.log"
			echo "$(date +%Y-%m-%d:%H:%M:%S) -  ApresMainHost - IP: $whois - $gregion , $gcountry  were blocked after $howman bad logins." >> $bcan/noty.log
			blog=/var/log
			    iffundir "$blog/secure.b"
			cp $blog/auth.log $blog/secure.b/secure-$(date +%F_%R)
			sdirc=$(ls $blog/secure.b | wc -l)
				if [[ $sdirc -gt 30 ]]; then
					tar -czvf $blog/secure.$(date +%F_%R).tar.gz $blog/secure.b/*
					rm -f $blog/secure.b/*
				fi
			>$blog/auth.log
			echo $whois > $bcan/whoisip.art
			    iffun "$bcan/bcount.art"
			bcount=$(cat $bcan/bcount.art)
			expr $bcount + 1 > $bcan/bcount.art

#				if [ $bcount -gt 750 ]; then
#				iptables -F
#				echo "Bcount has reached 750. all IP's were released" | /usr/sbin/sendmail -F Release-Anti-DDOS headhood20@gmail.com
#				fi
		fi

else
#			bcount=$(cat $bcan/bcount.art)
#			expr $bcount + 1 > $bcan/bcount.art
 exit 0
fi
#Alpha $1
