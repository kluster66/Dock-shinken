#ubuntu + shinken
#version 0.0.9
#
FROM ubuntu:latest
MAINTAINER Philippe "philippe.bazerbe@laposte.net"

#Depots, mises a jour et install
RUN 	apt-get update && \
	apt-get upgrade -y -q && \
	apt-get dist-upgrade -y -q && \
	apt-get -y -q autoclean && \
	apt-get -y -q autoremove

########### On télécharge tout ce qu'on va utiliser ici##########
# tout ce qui concerne Shinken 
RUN 	apt-get install -y -q 	wget \
				python-pycurl \
				python-setuptools \
				nagios-plugins

# tout ce qui concerne dnsmasq
RUN 	apt-get install -y -q dnsmasq 
# installation mongoDB
RUN 	apt-get install -y -q 	mongodb \
				python-pymongo


# tout les trucs optionnels
RUN 	apt-get install -y -q 	locate \
				ssh \
				curl \
				ntp

########## Tout ce qui concerne la configuration ############
#Partie 1 les users unix
# issue: le user dnsmasq se cree pendant l'install mais n'a pas de home associé
#création de l'utilisateur shinken

RUN 	useradd -m shinken 

#Installation de shinken

RUN 	cd /home/shinken && \
	wget http://www.shinken-monitoring.org/pub/shinken-2.0.4.tar.gz && \
	tar -xvzf shinken-2.0.4.tar.gz && \
	cd shinken-2.0.4 && \
	python setup.py install && \
	cd .. && \
	rm -rf shinken-2.0.4 &&\
	rm shinken-2.0.4.tar.gz

# on change le mot de passe de shinken et de dnsmasq
RUN 	echo 'shinken:shinken' | chpasswd
RUN 	echo 'dnsmasq:dnsmasq' | chpasswd

# Partie 2 configuration de dnsmasq
ADD  	./conf_files/dnsmasq.conf /etc/
ADD 	./conf_files/gen_0hosts.sh /home/shinken/

#ADD ./conf_files/conf_files /home/shinken/
RUN 	chmod 755 /home/shinken/gen_0hosts.sh

# google dns
RUN 	echo 'nameserver 8.8.8.8' >> /etc/resolv.dnsmasq.conf
RUN 	echo 'nameserver 8.8.4.4' >> /etc/resolv.dnsmasq.conf

# partie 3 configuration shinken
RUN 	chmod u+s /usr/lib/nagios/plugins/check_icmp && \
	ln -s /usr/lib/nagios/plugins/utils.pm /usr/share/perl5

#installation des modules

RUN 	su - shinken -c 'shinken --init' && \ 
	su - shinken -c 'shinken install webui' && \
	su - shinken -c 'shinken install auth-cfg-password' && \
	su - shinken -c 'shinken install mod-mongodb' && \
	su - shinken -c 'shinken install linux-snmp'

ADD 	./conf_files/broker-master.cfg /etc/shinken/brokers/
ADD 	./conf_files/webui.cfg /etc/shinken/modules/
ADD 	./conf_files/my_commands.sh /home/shinken/
ADD 	./conf_files/logFiles_linux.conf /var/lib/shinken/libexec/


RUN 	chmod 665 /etc/shinken/brokers/broker-master.cfg
RUN 	chmod 655 /etc/shinken/modules/webui.cfg
RUN 	chmod 655 /home/shinken/my_commands.sh
RUN 	chmod 655 /var/lib/shinken/libexec/logFiles_linux.conf

ADD 	./conf_files/gen_hosts.sh /home/shinken/
RUN 	chmod 755 /home/shinken/gen_hosts.sh

# partie 4 on construit les fichiers de parametre

#RUN /home/shinken/gen_0hosts.sh
#RUN /home/shinken/gen_hosts.sh
RUN 	updatedb


#répertoire ou je vais etre quand je vais me connecter
WORKDIR /home/shinken/

#Shinken ecoute sur le port 5000
EXPOSE 5000

#Démarrage des services
CMD 	/home/shinken/my_commands.sh

