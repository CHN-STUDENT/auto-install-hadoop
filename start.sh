#!/bin/bash
[ $(id -u) != "0" ] && { echo "${CFAILURE}Error: You must run this as root or sudo.${CEND}"; exit 1; }
echo "deb http://mirrors.aliyun.com/ubuntu/ xenial main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ xenial-security main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ xenial-updates main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ xenial-backports main restricted universe multiverse
" > /etc/apt/sources.list
apt-get update
apt-get upgrade -y
apt-get install -y vim openssh-server openjdk-8-jdk wget tar pdsh
echo 'JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"' >> /etc/environment
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
source /etc/environment
echo "create hadoop user，the password is hadoop"
useradd -m hadoop -s /bin/bash
echo hadoop:hadoop|chpasswd
adduser hadoop sudo
adduser hadoop root
wget -O hadoop-3.0.0.tar.gz http://mirrors.tuna.tsinghua.edu.cn/apache/hadoop/common/hadoop-3.0.0/hadoop-3.0.0.tar.gz
tar -zxf hadoop-3.0.0.tar.gz -C /usr/local
cd /usr/local/
mv ./hadoop-3.0.0/ ./hadoop
chown -R hadoop ./hadoop
cd /usr/local/hadoop
export PATH=$PATH:/usr/local/hadoop/bin
echo "export PATH=$PATH:/usr/local/hadoop/bin" >> /home/hadoop/.bashrc
echo "export PDSH_RCMD_TYPE=ssh" >> /home/hadoop/.bashrc
source /home/hadoop/.bashrc
export PDSH_RCMD_TYPE=ssh
hadoop version
sudo -u hadoop ssh-keygen -t rsa -P '' -f /home/hadoop/.ssh/id_rsa
sudo -u hadoop cat /home/hadoop/.ssh/id_rsa.pub >> /home/hadoop/.ssh/authorized_keys
sudo -u hadoop chmod 0600 /home/hadoop/.ssh/authorized_keys
