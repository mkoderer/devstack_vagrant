#!/bin/bash
echo "
deb mirror://mirrors.ubuntu.com/mirrors.txt trusty main restricted universe multiverse
deb-src mirror://mirrors.ubuntu.com/mirrors.txt trusty main restricted universe multiverse
deb mirror://mirrors.ubuntu.com/mirrors.txt trusty-updates main restricted universe multiverse
deb-src mirror://mirrors.ubuntu.com/mirrors.txt trusty-updates main restricted universe multiverse
deb mirror://mirrors.ubuntu.com/mirrors.txt trusty-backports main restricted universe multiverse
deb-src mirror://mirrors.ubuntu.com/mirrors.txt trusty-backports main restricted universe multiverse
deb mirror://mirrors.ubuntu.com/mirrors.txt trusty-security main restricted universe multiverse
deb-src mirror://mirrors.ubuntu.com/mirrors.txt trusty-security main restricted universe multiverse" > /etc/apt/sources.list

apt-get update 
apt-get -y install git python-pip vim libmysqlclient-dev
pip install git-review tox flake8
git clone git://git.openstack.org/openstack-dev/devstack 

#manila
MANILA_DIR=/git/manila/contrib/devstack
cp $MANILA_DIR/lib/manila /home/vagrant/devstack/lib
cp $MANILA_DIR/extras.d/70-manila.sh /home/vagrant/devstack/extras.d

echo "
ADMIN_PASSWORD=ppp
MYSQL_PASSWORD=ppp
RABBIT_PASSWORD=ppp
SERVICE_TOKEN=ppp
SERVICE_PASSWORD=ppp

enable_service tempest

disable_service n-net
enable_service q-svc
enable_service q-agt
enable_service q-dhcp
enable_service q-l3
enable_service q-meta
enable_service neutron
enable_service manila
enable_service m-api
enable_service m-shr
enable_service m-sch
" > /home/vagrant/devstack/localrc

mkdir /opt/stack
ln -s /git/tempest /opt/stack/tempest

chown vagrant:vagrant /opt/stack
chown -R vagrant:vagrant devstack
