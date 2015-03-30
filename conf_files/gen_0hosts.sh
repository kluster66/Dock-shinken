#! /bin/bash  

while IFS=: read hostname ip
do  
	echo 'address="/'$hostname'/'$ip'"' >> /etc/dnsmasq.d/0hosts
done < /home/shinken/params/shinken_hosts 
