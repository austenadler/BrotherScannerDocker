FROM ubuntu:16.04

RUN apt-get -y update && apt-get -y upgrade && apt-get -y clean
RUN apt-get -y install sane sane-utils ghostscript netpbm x11-common- wget graphicsmagick curl ssh sshpass && apt-get -y clean

ARG BRSCAN_VERSION=brscan4-0.4.5.1 BRSCAN_SKEY_VERSION=brscan-skey-0.2.4-1

RUN cd /tmp && \
    wget "http://download.brother.com/welcome/dlf006645/${BRSCAN_VERSION}.amd64.deb" && \
    dpkg -i "/tmp/${BRSCAN_VERSION}.amd64.deb" && \
    rm "/tmp/${BRSCAN_VERSION}.amd64.deb"

RUN cd /tmp && \
    wget "http://download.brother.com/welcome/dlf006652/${BRSCAN_SKEY_VERSION}.amd64.deb" && \
    dpkg -i "/tmp/${BRSCAN_SKEY_VERSION}.amd64.deb" && \
    rm "/tmp/${BRSCAN_SKEY_VERSION}.amd64.deb"

ADD files/runScanner.sh /opt/brother/runScanner.sh

ENV NAME="Scanner"
ENV MODEL="MFC-L2700DW"
ENV IPADDRESS="192.168.1.123"
ENV USERNAME="NAS"

#only set these variables, if inotify needs to be triggered (e.g., for CloudStation):
ENV SSH_USER="admin"
ENV SSH_PASSWORD="admin"
ENV SSH_HOST="localhost"
ENV SSH_PATH="/path/to/scans/folder/"

#only set these variables, if you need FTP upload:
ENV FTP_USER="scanner"
ENV FTP_PASSWORD="scanner"
ENV FTP_HOST="ftp.mydomain.com"
ENV FTP_PATH="/"

EXPOSE 54925
EXPOSE 54921

#directory for scans:
VOLUME /scans

#directory for config files:
VOLUME /opt/brother/scanner/brscan-skey

CMD /opt/brother/runScanner.sh
