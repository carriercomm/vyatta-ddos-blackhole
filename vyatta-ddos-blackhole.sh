#!/bin/bash

wan="eth3.3"
prefixlist="pf-blackhole-out"
qtdpacotes_ddos="2000"
qtdpacotes_tcpdump="5000"

tcpdump -n -s0 -i $wan |head -$qtdpacotes_tcpdump > /tmp/ataque.txt 2> /dev/null

VAR=`cat /tmp/ataque.txt | cut -d " " -f 5 | cut -d ":" -f1| sort |uniq -d -c|sort |tail -n1`

IP=`echo $VAR |cut -d " " -f 2 |cut -d "." -f -4`
QTD=`echo $VAR |cut -d " " -f 1`

DATA=`date`

if [ $QTD -gt $qtdpacotes_ddos ]
then
  echo "O IP sendo atacado eh $IP com $QTD pacotes em $DATA" >> /root/ataques.txt
  vtysh -c "configure terminal" -c "ip prefix-list $prefixlist seq $(($RANDOM % 20)) permit $IP/32" -c "ip route $IP/32 null0"

fi

