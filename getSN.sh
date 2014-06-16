#!/bin/bash

numOfRadios=2
count=2
source "/root/.bashrc"

if [ $# -eq 0 ]
then 
  echo "usage: getSN.sh -[ip, nm, wc, mc] [OID]"
fi
if [ $# -eq 1 ]
then
  case $1 in
    -ch) snmpwalk -v 2c -c public -m all -Os 172.20.200.9   .1.3.6.1.4.1.8744.5.25.1.2.1.1.5
      ;;
    -ip) snmpwalk -v 2c -c public -m all -Os 172.20.200.9   .1.3.6.1.4.1.8744.5.23.1.2.1.1.4 
      ;;
    -nm) snmpwalk -c public -v 2c 172.20.200.9 -Osq .1.3.6.1.4.1.8744.5.23.1.2.1.1.6 
      ;;
    -wc) snmpwalk -c public -v 2c 172.20.200.9 -Osq  .1.3.6.1.4.1.8744.5.25.1.7.1.1.17 
      ;;
    -mc) snmpwalk -c public -v 2c 172.20.200.9 -Osq  .1.3.6.1.4.1.8744.5.25.1.7.1.1.2
      ;;
      *) echo "invalid"
      ;;
  esac
elif [ $# -eq 2 ]
then
  case $1 in
    -ch) snmpwalk -v 2c -c public -m all -Os 172.20.200.9   .1.3.6.1.4.1.8744.5.25.1.2.1.1.5.$2
      ;;
    -ip) #echo "get ip"
      snmpget -v 2c -c public -m all -Os 172.20.200.9   .1.3.6.1.4.1.8744.5.23.1.2.1.1.4.$2
      ;;
    -nm) snmpget -c public -v 2c 172.20.200.9 -Osq .1.3.6.1.4.1.8744.5.23.1.2.1.1.6.$2
      ;;
    -wc) snmpwalk -c public -v 2c 172.20.200.9 -Osq  .1.3.6.1.4.1.8744.5.25.1.7.1.1.17.$2
      ;;
    -mc) snmpwalk -c public -v 2c 172.20.200.9 -Osq  .1.3.6.1.4.1.8744.5.25.1.7.1.1.2.$2
        #snmpwalk -c public -v 2c 172.20.200.9 -Osq  .1.3.6.1.4.1.8744.5.25.1.7.1.1.2.$2 
      ;;
    -st) snmpwalk -c public -v 2c 172.20.200.9 -Osq .1.3.6.1.4.1.8744.5.25.1.7.1.1.7.$2
      ;;
      *) echo "invalid"
      ;;
  esac
elif [ $# -eq 3 ]
then
  case $1 in
    -mc) snmpwalk -c public -v 2c 172.20.200.9 -Osq  .1.3.6.1.4.1.8744.5.25.1.7.1.1.2.$2.2.$3
        snmpwalk -c public -v 2c 172.20.200.9 -Osq  .1.3.6.1.4.1.8744.5.25.1.7.1.1.2.$2.1.$3
      ;;
    -st) snmpwalk -c public -v 2c 172.20.200.9 -Osq  .1.3.6.1.4.1.8744.5.25.1.7.1.1.7.$2.1.$3
        snmpwalk -c public -v 2c 172.20.200.9 -Osq  .1.3.6.1.4.1.8744.5.25.1.7.1.1.7.$2.2.$3
      ;;
    -wc) snmpwalk -c public -v 2c 172.20.200.9 -Osq  .1.3.6.1.4.1.8744.5.25.1.7.1.1.17.$2.2.$3
        snmpwalk -c public -v 2c 172.20.200.9 -Osq  .1.3.6.1.4.1.8744.5.25.1.7.1.1.17.$2.1.$3
      ;;
      *) echo "invalid"
      ;;
  esac
elif [ $# -eq 4 ]
then
  case $1 in
    -st) snmpwalk -c public -v 2c 172.20.200.9 -Osq  .1.3.6.1.4.1.8744.5.25.1.7.1.1.7.$2.$3.$4
      ;;
    -ip) res=`snmpwalk -c public -v 2c 172.20.200.9 -Osq  .1.3.6.1.4.1.8744.5.25.1.7.1.1.17.$2.$3.$4`
        echo $res
      ;;
    -mc) res=`snmpwalk -c public -v 2c 172.20.200.9 -Osq  .1.3.6.1.4.1.8744.5.25.1.7.1.1.2.$2.$3.$4`
        echo $res
      ;;
    -mi) res1=`snmpwalk -c public -v 2c 172.20.200.9 -Osq  .1.3.6.1.4.1.8744.5.25.1.7.1.1.2.$2.$3.$4`
        res2=`snmpwalk -c public -v 2c 172.20.200.9 -Osq  .1.3.6.1.4.1.8744.5.25.1.7.1.1.17.$2.$3.$4`
        res3=`echo $res1 | cut -d\" -f2`
        res4=`echo $res2 | awk '{print $2}'`
        echo "$res3@$res4"
      ;;
    -st) snmpwalk -c public -v 2c 172.20.200.9 -Osq .1.3.6.1.4.1.8744.5.25.1.7.1.1.7.$2.$3.$4
      ;;
  esac
fi
