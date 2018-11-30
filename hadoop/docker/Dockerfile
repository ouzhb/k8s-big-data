FROM centos:7.5.1804

MAINTAINER RuijieBigdata

ARG HADOOP_VERSION="hadoop-2.7.7"
ARG JAVA_FILE_NAME="jdk-8u152-linux-x64.rpm"

USER root
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime;

# ssh config
RUN yum install -y initscripts openssh-clients openssh-server epel-release; \
    yum -y install python-pip; \
    echo "kcuf" | passwd root --stdin; \
    ssh-keygen -A; \
    pip install --upgrade pip; \
    pip install paramiko

# java
COPY packages/${JAVA_FILE_NAME} /opt/ruijie/install/${JAVA_FILE_NAME}
RUN mkdir -p /usr/share/man/man1/; \
    rpm -i /opt/ruijie/install/${JAVA_FILE_NAME} ; \
    rm /opt/ruijie/install/${JAVA_FILE_NAME}; \
    rm /usr/bin/java ; \
    ln -s $JAVA_HOME/bin/java /usr/bin/java

# hadoop
COPY packages/${HADOOP_VERSION}.tar.gz /opt/ruijie/install/${HADOOP_VERSION}.tar.gz
RUN tar -xvf /opt/ruijie/install/${HADOOP_VERSION}.tar.gz -C /usr/local/; \
    rm /opt/ruijie/install/${HADOOP_VERSION}.tar.gz; \
    ln -s /usr/local/${HADOOP_VERSION}/ /usr/local/hadoop; \
    chown -R root:root /usr/local/hadoop/;
COPY packages/which /usr/bin/which
RUN chown -R root:root /usr/bin/which; \
    chmod +x /usr/bin/which;

#COPY config/single /etc/hadoop/single
#COPY config/cluster /etc/hadoop/cluster
#RUN chown -R root:root /etc/hadoop;

# env
ENV JAVA_HOME /usr/java/default
ENV JRE_HOME /usr/java/default/jre
ENV CLASSPATH .:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar:$JRE_HOME/lib
ENV HADOOP_HOME /usr/local/hadoop
ENV HADOOP_PREFIX /usr/local/hadoop
ENV PATH $PATH:$JAVA_HOME/bin:$JRE_HOME/bin:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

ADD bootstrap.py /etc/bootstrap.py
RUN chown root:root /etc/bootstrap.py && chmod 700 /etc/bootstrap.py

ENTRYPOINT ["/etc/bootstrap.py"]