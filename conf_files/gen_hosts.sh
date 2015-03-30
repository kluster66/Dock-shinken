#! /bin/sh

while IFS=: read hostname ip
do
echo 'define host{
\t use \t  linux-snmp
\t host_name \t '$hostname'
\t address \t' $ip' 
}' > /etc/shinken/hosts/hosts_$hostname.cfg

done < /home/shinken/params/shinken_hosts
