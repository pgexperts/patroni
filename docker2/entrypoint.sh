#!/bin/bash

DOCKER_IP=$(hostname --ip-address)

cat > /etc/patroni/patroni.yml <<__EOF__

scope: &scope ${CLUSTER}
ttl: &ttl 30
loop_wait: &loop_wait 10
restapi:
  listen: ${DOCKER_IP}:8001
  connect_address: ${DOCKER_IP}:8001
  auth: '${APIUSER}:${APIPASS}'
  certfile: /etc/ssl/certs/ssl-cert-snakeoil.pem
  keyfile: /etc/ssl/private/ssl-cert-snakeoil.key
etcd:
  scope: *scope
  ttl: *ttl
  host: 127.0.0.1:4001
postgresql:
  name: ${NODE}
  scope: *scope
  listen: 0.0.0.0:5432
  connect_address: ${DOCKER_IP}:5432
  data_dir: /pgdata/data
  maximum_lag_on_failover: 10485760 # 10 megabyte in bytes
  pg_hba:
  - host all all 0.0.0.0/0 md5
  - hostssl all all 0.0.0.0/0 md5
  - host replication ${REPUSER} ${DOCKER_IP}/16    md5
  replication:
    username: ${REPUSER}
    password: ${REPPASS}
    network:  ${DOCKER_IP}/32
  superuser:
    password: ${SUPERPASS}
  restore: patroni/scripts/restore.py
  admin:
    username: ${ADMINUSER}
    password: ${ADMINPASS}
  parameters:
    archive_mode: "off"
    archive_command: mkdir -p ../wal_archive && cp %p ../wal_archive/%f
    wal_level: hot_standby
    max_wal_senders: 7
    hot_standby = "on"
__EOF__

if [ "${PGVERSION}" -eq "9.3" ]
then
    cat >> /etc/patroni/patroni.yml <<__EOF__
    wal_keep_segments = 10
__EOF__
else
    cat >> /etc/patroni/patroni.yml <<__EOF__
    max_replication_slots = 7
__EOF__
fi

cat /etc/patroni/postgres.yml

exec patroni /etc/patroni/patroni.yml

