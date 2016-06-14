FROM ubuntu:14.04

# update
RUN sudo apt-get -y update

# ssh
RUN apt-get install -y curl openssh-server
RUN ssh-keygen -q -N "" -t rsa -f /root/.ssh/id_rsa
RUN cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys

# java
RUN mkdir -p /usr/java/default && \
    curl -Ls 'http://download.oracle.com/otn-pub/java/jdk/7u51-b13/jdk-7u51-linux-x64.tar.gz' -H 'Cookie: oraclelicense=accept-securebackup-cookie' | \
    tar --strip-components=1 -xz -C /usr/java/default/

ENV JAVA_HOME /usr/java/default/
ENV PATH $PATH:$JAVA_HOME/bin

# python
RUN sudo apt-get -y install python python-apsw && sudo apt-get -y update

# exareme
RUN apt-get -y install git maven && sudo apt-get -y update
RUN git clone https://github.com/madgik/exareme.git -b mip /root/exareme-mip
WORKDIR /root/exareme-mip

RUN sudo apt-get install -y python-numpy python-scipy python-matplotlib ipython ipython-notebook python-pandas python-sympy python-nose && sudo apt-get -y update
RUN sudo apt-get install -y python-pip && sudo apt-get -y update && sudo pip install -r requirements.txt

RUN mvn clean install -DskipTests
WORKDIR /root
RUN ln -s /root/exareme-mip/exareme-distribution/target/exareme /root/exareme

WORKDIR /root/exareme
ADD bootstrap.sh /root/exareme/bootstrap.sh
EXPOSE 9090 1098 1099 8088

ENTRYPOINT /bin/bash -x bootstrap.sh

