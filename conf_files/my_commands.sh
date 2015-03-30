# configuration de dnsmasq et de shinken 
/home/shinken/gen_0hosts.sh
/home/shinken/gen_hosts.sh

# on démarre les services

service dnsmasq start 
service shinken start

while true;
do
	/home/shinken/gen_0hosts.sh
	/home/shinken/gen_hosts.sh
	sleep 120
done



