

while read ligne  
do  
	if [ `echo $ligne | cut -c1` !=  '#' ];
	then    
		echo $ligne
	fi

done < shinken_hosts.sauv 
