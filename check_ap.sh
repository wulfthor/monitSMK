#!/bin/bash 

#source "/root/.bashrc"

log="/home/thw/nagios/nnlog.txt"

HOSTIP=$1
ACTION=$2
SNMPWALK="/usr/bin/snmpwalk"
EXITSTRING=''
PERFDATA=''
ipOID=''


# Convert IP to OID
#ipOID=`/home/thw/bin/getOIDFromIP.sh $HOSTIP`
#  echo "$HOSTIP and $ipOID " >> $log
ipOID=`/usr/bin/mysql -A -uroot -proot123 --skip-column-names  nagios -e "select oid from apmapping where ip = '$1';"`

function fwcount(){
WC=`$SNMPWALK -c public -v 2c 172.20.200.9 -Osq  .1.3.6.1.4.1.8744.5.25.1.7.1.1.17.$1 | wc | awk '{print $1}'`
echo "OK: WCCount is $WC|Wclients=$WC;;;"
echo "$HOSTIP and $1 WCCount is $WC, OK|Wclients=$WC;;;" >> $log
exit 0
}

function ftcount(){
WT=`$SNMPWALK -c public -v 2c 172.20.200.9 -Osq  .1.3.6.1.4.1.8744.5.25.1.7.1.1.17 | wc | awk '{print $1}'`
echo "OK: WTCount is $WT|WTclients=$WT;;;"
exit 0
}

if [ "$ACTION" = "WC"  ]
then
  fwcount $ipOID
elif [ "$ACTION" = "WT"  ]
then
  ftcount 
fi

