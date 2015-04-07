#! /bin/sh

while read lines 
do 
if [ lines | cut -c1` = '#' ]
then
    echo lines
fi
#IFS=: read hostname ip
#echo 'define host{
#\t use \t  linux-snmp
#\t host_name \t '$hostname'
#\t address \t' $ip' 
#}' > ./poubelle/hosts_$hostname.cfg

done < echo ./poubelle/shinken_hosts | grep -v "#"
