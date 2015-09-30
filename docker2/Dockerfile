# This dockerfile is meant to help with setup and testing of 
# patroni nodes.  Unlike the prior docker setup, it relies on 
# docker compose to set up multiple nodes.

FROM ubuntu:trusty

ADD . /setup/

RUN /setup/docker2/package_install.sh 9.3

RUN /setup/docker2/file_setup.sh

EXPOSE 8001 5432

ENTRYPOINT

ENTRYPOINT ["/bin/bash", "/setup/docker2/entrypoint.sh"]
USER postgres
