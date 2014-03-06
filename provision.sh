apt-get update

#add oracle repos
apt-get install -y software-properties-common
apt-get install -y python-software-properties
add-apt-repository -y ppa:webupd8team/java

# install java from oracle
apt-get update
echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
apt-get install -y oracle-java6-installer 2>/dev/null
export JAVA_HOME=/usr/lib/jvm/java-6-oracle

# Add JAVA_HOME to base environment variables and make it visible to sudoers
echo 'JAVA_HOME="/usr/lib/jvm/java-6-oracle"' >>/etc/environment
echo "Defaults env_keep+=JAVA_HOME" >>/etc/sudoers

#download and extract hadoop 
wget -O hadoop.tar.gz http://apache.claz.org/hadoop/common/hadoop-1.2.1/hadoop-1.2.1.tar.gz 
tar -xvf hadoop.tar.gz
rm -f hadoop.tar.gz

#copy hadoop xmls
cp /vagrant/conf/* /home/vagrant/hadoop-1.2.1/conf
chown -R vagrant:vagrant /home/vagrant/hadoop-1.2.1/
su vagrant -c "/home/vagrant/hadoop-1.2.1/bin/hadoop namenode -format"

echo "
export HADOOP_HOME=/home/vagrant/hadoop-1.2.1
export PATH=$PATH:/home/vagrant/hadoop-1.2.1/bin
" >> /home/vagrant/.bashrc

echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config

#copy ssh
mkdir -p /home/vagrant/.ssh
chmod 700 /home/vagrant/.ssh
chown -R vagrant:vagrant /home/vagrant/.ssh
su vagrant -c "ssh-keygen -t rsa -P '' -f /home/vagrant/.ssh/id_rsa"
cat /home/vagrant/.ssh/id_rsa.pub >> .ssh/authorized_keys 


#download zookeeper
apt-get install zookeeper

#download rabbitMQ
apt-get install erlang-asn1 erlang-base erlang-corba erlang-crypto erlang-dev erlang-diameter erlang-docbuilder erlang-edoc erlang-erl-docgen erlang-eunit erlang-ic erlang-inets erlang-inviso erlang-mnesia erlang-nox erlang-odbc erlang-os-mon erlang-parsetools erlang-percept erlang-public-key erlang-runtime-tools erlang-snmp erlang-ssh erlang-ssl erlang-syntax-tools erlang-tools erlang-webtool erlang-xmerl libltdl7 libodbc1 libsctp1 lksctp-tools
wget https://www.rabbitmq.com/releases/rabbitmq-server/v3.1.5/rabbitmq-server_3.1.5-1_all.deb
sudo dpkg -i rabbitmq-server_3.1.5-1_all.deb
rm rabbitmq-server_3.1.5-1_all.deb

#enable rabbitMQ alugin
sudo /usr/lib/rabbitmq/bin/rabbitmq-plugins enable rabbitmq_management
sudo service rabbitmq-server reload
