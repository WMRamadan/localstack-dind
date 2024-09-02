FROM ubuntu:24.04

COPY ./filesystem /.

RUN sh /mnt/pre-install.sh
RUN sh /mnt/install-terraform.sh
RUN sh /mnt/install-awscli.sh
