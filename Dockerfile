FROM ubuntu:13.10
MAINTAINER Kuba Kucharski <kuba@zenmakers.co>

RUN mkdir /disk

RUN useradd docker
RUN echo "docker:docker" | chpasswd

RUN apt-get update
RUN apt-get install -y git screen sudo python-pip joe openssh-server supervisor 
RUN apt-get install -y build-essential make g++ libtool autotools-dev autoconf python-dev
RUN echo 'root:password' |chpasswd

RUN mkdir /var/run/sshd
RUN echo export LC_ALL=\"en_US.UTF-8\" > /root/.bash_profile

WORKDIR /disk



RUN git clone https://github.com/orisi/orisi.git /disk/orisi
RUN git clone https://github.com/orisi/oracle.git /disk/oracle

RUN chmod +x /disk/oracle/docker_install.sh

RUN /disk/oracle/docker_install.sh

RUN chown -R docker /disk
RUN chown -R docker /disk/*


ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
EXPOSE 22 8333 8444 2523


RUN chmod +x /disk/oracle/initial_oracle_run.sh
RUN chmod +x /disk/oracle/initial_bitcoind_run.sh

RUN cp /disk/oracle/initial* /usr/bin/
RUN chmod 755 /var/run/screen

VOLUME /disk

CMD ["/usr/bin/supervisord"]
