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


# exareme
RUN apt-get -y install git maven
RUN git clone https://github.com/dbilid/exareme.git /root/exareme-src
WORKDIR /root/exareme-src
RUN mvn clean install -DskipTests
RUN mv /root/exareme-src/exareme-distribution/target/exareme* /root/exareme

# python
RUN sudo apt-get -y install python python-dev

# sqlite
WORKDIR /root/
ADD sqlite-amalgamation-3150000.zip /root/sqlite-amalgamation-3150000.zip
RUN apt-get -y install gcc
RUN unzip sqlite-amalgamation-3150000.zip
WORKDIR /root/sqlite-amalgamation-3150000
RUN sed -i  's/define SQLITE_MAX_ATTACHED 10/define SQLITE_MAX_ATTACHED 125/g' sqlite3.c
RUN gcc -DSQLITE_MAX_ATTACHED=125 -shared -o libsqlite3.so -fPIC shell.c sqlite3.c -lpthread -ldl

# apsw
WORKDIR /root/
ADD apsw-3.15.0-r1.zip /root/apsw-3.15.0-r1.zip
RUN unzip apsw-3.15.0-r1.zip
WORKDIR /root/apsw-3.15.0-r1/sqlite3
RUN cp /root/sqlite-amalgamation-3150000/* .
WORKDIR /root/apsw-3.15.0-r1
RUN python setup.py build install


EXPOSE 9090
WORKDIR /root/exareme

# bootstrap
ADD bootstrap.sh /root/exareme/bootstrap.sh
ENTRYPOINT /bin/bash bootstrap.sh

