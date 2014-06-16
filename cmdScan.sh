#!/bin/bash

#050514_1459
#snmpwalk -c public -v 2c 172.20.200.9 -Osq .1.3.6.1.4.1.8744.5.25.1.7.1.1.7.6.2.1 @ 20 10 7A 60 5F 6A
#snmpwalk -c public -v 2c 172.20.200.9 -Osq .1.3.6.1.4.1.8744.5.25.1.7.1.1.7.7.1.1 @ 84 7A 88 78 A4 42
#snmpwalk -c public -v 2c 172.20.200.9 -Osq .1.3.6.1.4.1.8744.5.25.1.8.1.1.3.18.2.11
#SNMPv2-SMI::enterprises.8744.5.25.1.8.1.1.3.18.2.11 = Counter64: 887554

#enterprises.8744.5.25.1.7.1.1.2.1.1.2 "1C B0 94 A7 D1 32 "

#update linktoAP set snr="No" where cl_mac=" 68 09 27 B9 5D 91"

#returns 69,2,4,"50 2E 5C 03 A0 C8"

count=0
myIpods="/home/thw/tmp/ipods_mac"
myLogs="/home/thw/tmp/cmdlog"
onlyIpods=1
timest="`echo $source | cut -d\. -f2`"
sncmd="snmpwalk -c public -v 2c 172.20.200.9 -Osq "
source=$1

echo "----- `date` ------" >> $myLogs

MYDATE=`echo $source | cut -d\. -f2`


cat $source  | while read x
do 
  echo "source: $x" >> $myLogs
  oidpart=`echo "$x" | cut -d\" -f1`
  macpart=`echo "$x" | cut -d\" -f2 | sed 's/ $//g'`
  if [ $onlyIpods -eq 1 ]; then
    grres=`grep "$macpart" $myIpods | awk '{print $1}'`
  else
    grres=1
  fi
  if [ -n "$grres" ]; then
    ap_ch_oi=`echo $oidpart | sed -e 's/^enter.*\.1\.2\.\([0-9]\{1,\}\)\.\([0-9]\)\.\([0-9]\{1,\}\)/\1,\2,\3/g'`
    cmd=`echo $oidpart | sed 's/7\.1\.1\.2/7\.1\.1\.7/g'`
    #cmd2=`echo $oidpart | sed 's/7\.1\.1\.2/8\.1\.1\.3/g'`
    cmd2=`echo $oidpart | sed 's/7\.1\.1\.2/8\.1\.1\.4/g'`
    cmd3=`echo $oidpart | sed 's/7\.1\.1\.2/7\.1\.1\.17/g'`
    snr=`$sncmd $cmd | awk '{print $2}'`
    dtr=`$sncmd $cmd2 | awk '{print $2}'` 
    ip=`$sncmd $cmd3 | awk '{print $2}'` 
    echo "ip : $ip" >> $myLogs
    echo "ap_c : $ap_ch_oi_mac" >> $myLogs
    echo "snr : $snr" >> $myLogs
    echo "dtr : $dtr" >> $myLogs
    echo "oid : $oidpart" >> $myLogs
    echo "cmd : $cmd" >> $myLogs
    echo "cmd2: $cmd2" >> $myLogs
    echo "insert into linktoAP (timestring, ap_oid,cl_ch,cl_oid,cl_mac,cl_id,snr,cl_pack,cl_ip) values (\"$MYDATE\",$ap_ch_oi,\"$macpart\",$grres,$snr,$dtr,\"$ip\");"
    echo "insert into linktoAP (timestring, ap_oid,cl_ch,cl_oid,cl_mac,cl_id,snr,cl_pack,cl_ip) values (\"$MYDATE\",$ap_ch_oi,\"$macpart\",$grres,$snr,$dtr,\"$ip\");" >> $myLogs
  else
    echo "not $macpart ipod" >> $myLogs
  fi
done
