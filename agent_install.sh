#!/bin/bash
# Script for instll puppet agent
# Auther: Frank Zhang
# Email : 18610041259@qq.com
# Data  : 2015-10-13
# Version: 1.0

# Process:
# 1. Get Local hostname/IP and Server hostname
# 2. Set /etc/hosts file to add Server hostname resolve
# 3. Instll  puppet agent and setup
# 4. Inatall mcollective server and setup

# Get command var and give Prog Help when command is wrong

COMMAND_EVAL=0
PROG=$0

if [ "$1" = "install" ] ; then
	if [ $# == 3 ] ; then
		PUPPET_MASTER=$2
		PUPPET_MASTER_IP=$3
		COMMAND_EVAL=1
	fi
fi

if [ "$COMMAND_EVAL" = "0" ] ; then
	echo "Usage: $PROG <command>" 
	echo "Command:"
	echo "  $PROG install <master_name> <master_ip>  Install puppet on this host"
	echo "  $PROG help                               Get help message"
	echo "     "
	exit 1
fi

if [ -f /etc/puppet/agent_installed.flag ] ; then
	echo " The puppet agent has installed, Are you want re-install? ('yes' for continue,other quit):"
	read answer
	if [ "x"$answer != "xyes" ] ; then
		exit 1
	fi
fi

# get Local hostname and IP

HOSTNAME=`hostname -f`
if [ $? != 0 ] ; then
	echo "  Can not get FQDN hostname of this host,Please insert line into /etc/hosts"
	echo "  For example : '192.168.0.31  test.example.com' "
	exit 1
fi
HOSTIP=`hostname -i $HOSTNAME`
if [ $? != 0 ] ; then
	echo "  Can not get FQDN hostname of this host,Please insert line into /etc/hosts"
	echo "  For example : '192.168.0.31  test.example.com' "
	exit 1
fi

clear
echo " Note: Before install, you need put hostip and hostname in /etc/hosts"
echo "       And you must sync the time between your host and puppet server"
echo "       Ask your administator put your hostname into autosign config on puppet master"
echo ""
echo " Your host name is $HOSTNAME, host ip is $HOSTIP"
echo " Puppet  Server Name is $PUPPET_MASTER, Server IP is $PUPPET_MASTER_IP"
echo " Please verify there correct！！！"
echo ""
echo " Contine Install? ('yes' for continue,other quit):"
read answer
if [ "x"$answer != "xyes" ] ; then
	exit 1
fi

# set /etc/hosts file to add server resolve

grep "$PUPPET_MASTER_IP *$PUPPET_MASTER" /etc/hosts
if [ $? != 0 ] ; then
	echo "$PUPPET_MASTER_IP    $PUPPET_MASTER"  >> /etc/hosts
fi
# set puppet yum repo

cat > /etc/yum.repos.d/puppet_agent.repo << EOF1
[puppet_agent]
name = Puppet Agent yum repo ,Taikang
baseurl=http://192.168.56.30/puppet_yum
enabled=0
gpgcheck=0
EOF1

# install puppet agent
yum --enablerepo=puppet_agent -y install puppet
# install mcollective server
yum --enablerepo=puppet_agent install -y mcollective mcollective-common mcollective-puppet-common mcollective-puppet-agent

# Configure puppet agent

cat > /etc/puppet/puppet.conf << EOF2
[main]
    logdir = /var/log/puppet
    rundir = /var/run/puppet
    ssldir = $vardir/ssl

[agent]
    classfile = $statedir/classes.txt
    localconfig = $vardir/localconfig
    default_schedules = false

    report            = true
    pluginsync        = true
    masterport        = 8140
    environment       = production
    certname          = $HOSTNAME
    server            = $PUPPET_MASTER
    listen            = false
    splay             = false
    splaylimit        = 1800
    runinterval       = 1800
    noop              = false
    configtimeout     = 120
    usecacheonfailure = true
EOF2
puppet agent -tv
sleep 2

# Configure mcollective

cat > /etc/mcollective/server.cfg << EOF3
main_collective = mcollective
collectives = mcollective
libdir = /usr/libexec/mcollective
logfile = /var/log/mcollective.log
loglevel = info
daemonize = 1

# Plugins
securityprovider = psk
plugin.psk = iPQaoo8DhsTlcbGq

connector = activemq
plugin.activemq.pool.size = 1
plugin.activemq.pool.1.host = $PUPPET_MASTER
plugin.activemq.pool.1.port = 61613
plugin.activemq.pool.1.user = mcollective
plugin.activemq.pool.1.password = Oracle119

# Facts
factsource = yaml
plugin.yaml = /etc/mcollective/facts.yaml

EOF3

chkconfig mcollective on
service mcollective restart

# touch a installed flag
touch /etc/puppet/agent_installed.flag

# clear install temp file
rm -f /etc/yum.repos.d/puppet_agent.repo

