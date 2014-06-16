#!/bin/bash 


mybin="/home/thw/bin"
myLog="/home/thw/logs/apscan.log"
myRunDir="/home/thw/nagios/AP/test"
myFileDir="/home/thw/nagios/AP/test/output$$"
now=`date +%d%m%y_%H%M`
mkdir $myFileDir

echo "------- `date` -------" >> $myLog
echo "1 running $mybin/getSN.sh -mc > $myFileDir/scan.$now" >> $myLog
$mybin/getSN.sh -mc > $myFileDir/scan.$now
echo "2 running $myRunDir/cmdScan.sh $myFileDir/scan.$now > $myFileDir/intolinkAP.sql" >> $myLog
$myRunDir/cmdScan.sh  $myFileDir/scan.$now > $myFileDir/intolinkAP.sql
echo "6 running /usr/bin/mysql -A -uroot -proot123  nagios <  $myFileDir/intolinkAP.sql" >> $myLog
/usr/bin/mysql -A -uroot -proot123  nagios <  $myFileDir/intolinkAP.sql
echo "done running " >> $myLog
echo "---------------- `date`--------------- " >> $myLog



