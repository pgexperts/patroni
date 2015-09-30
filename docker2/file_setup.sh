#!/bin/bash

mkdir /pgdata/
mkdir /pgdata/data
chown postgres:postgres /pgdata/data/
chmod 700 /pgdata 

mkdir /etc/patroni/
chown postgres:postgres /etc/patroni

mkdir /etc/wal-e.d/

mv /setup/patroni /patroni
chown -R postgres:postgres /patroni
chmod +x /patroni/*.py

