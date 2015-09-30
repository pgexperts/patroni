#!/bin/bash

PGVER="${1}"
apt-get update
apt-get -y -q install wget

# fix locale
apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
  && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

# setup apt-get to pull from apt.postgresql.org
echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main ${PGVER}" > /etc/apt/sources.list.d/pgdg.list
wget -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | apt-key add -

# update apt
apt-get update
apt-get -y -q install pgdg-keyring

# install some basics
apt-get -y -q install libreadline-dev
apt-get -y -q install openssl

# install postgresql and a bunch of accessories
apt-get -y -q install postgresql-client-${PGVER}
apt-get -y -q install postgresql-${PGVER}
apt-get -y -q install postgresql-contrib-${PGVER}
apt-get -y -q install postgresql-server-dev-${PGVER}
apt-get -y -q install libpq-dev

# put pg_ctl in postgres' path
ln -s /usr/lib/postgresql/${PGVER}/bin/pg_ctl /usr/bin/

#  install extensions
#apt-get -y -q install postgresql-${PGVER}-postgis-2.1 postgresql-${PGVER}-postgis-2.1-scripts

# install WAL-E requirements
apt-get -y -q install python-pip
apt-get -y -q install python-dev

# install WAL-E
pip install -U six
pip install -U requests
pip install -U wal-e
apt-get -y install daemontools
apt-get -y install lzop pv

# install patroni dependancies
apt-get -y install python-yaml
pip install -U setuptools
cd /setup/
python setup.py install

