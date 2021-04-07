FROM registry.redhat.io/codeready-workspaces/plugin-java8-rhel8

USER root
WORKDIR /opt

RUN yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y && \
    yum upgrade -y -q && \
    yum install vim -y -q; \
    yum install jq -y -q; \
    yum install httpd -y -q; \
    yum install yum-utils -y -q; \
    yum install net-tools -y -q

RUN wget https://archive.apache.org/dist/pulsar/pulsar-2.7.1/apache-pulsar-2.7.1-bin.tar.gz -q && \
    tar xvfz apache-pulsar-2.7.1-bin.tar.gz 1>/dev/null && \
    rm -rf apache-pulsar-2.7.1-bin.tar.gz; \
    echo 'PATH=$PATH:/opt/apache-pulsar-2.7.1/bin' > /etc/environment
