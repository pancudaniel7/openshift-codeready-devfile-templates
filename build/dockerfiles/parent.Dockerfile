FROM registry.redhat.io/codeready-workspaces/plugin-java8-rhel8

USER root
WORKDIR /opt

RUN yum update -y -q

RUN yum install yum-utils -y -q; \
    yum install vim -y -q; \
    yum install jq -y -q; \
    yum install httpd -y -q; \
    yum install net-tools -y -q; \
    yum install bind-utils -y -q; \
    yum install lsof -y -q

COPY keys/RPM-GPG-KEY-centos-packages /etc/rpm-gpg/RPM-GPG-KEY-centos-packages
RUN rpm --import /etc/rpm-gpg/RPM-GPG-KEY-centos-packages && \
    rpm --checksig http://mirror.centos.org/centos/8/AppStream/x86_64/os/Packages/telnet-0.17-73.el8_1.1.x86_64.rpm && \
    rpm -ivh http://mirror.centos.org/centos/8/AppStream/x86_64/os/Packages/telnet-0.17-73.el8_1.1.x86_64.rpm

COPY keys/apache-pulsar-2.7.1-bin.tar.gz.sha512 apache-pulsar-2.7.1-bin.tar.gz.sha512
RUN wget https://archive.apache.org/dist/pulsar/pulsar-2.7.1/apache-pulsar-2.7.1-bin.tar.gz -q && \
    echo "$(cat apache-pulsar-2.7.1-bin.tar.gz.sha512)" | sha512sum --check && \
    tar xvfz apache-pulsar-2.7.1-bin.tar.gz 1>/dev/null && \
    rm -rf apache-pulsar-2.7.1-bin.tar.gz && \
    echo 'PATH=$PATH:/opt/apache-pulsar-2.7.1/bin' > /etc/environment

RUN curl -sSL http://github.com/ahmetb/kubectx/archive/v0.3.1.tar.gz | tar -C /usr/local/ -xz && \
    export PATH=/usr/local/kubectx-0.3.1:$PATH

RUN sudo apt update;sudo apt install -y gnupg && \
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3EFE0E0A2F2F60AA && \
    echo "deb http://ppa.launchpad.net/tektoncd/cli/ubuntu eoan main"|sudo tee /etc/apt/sources.list.d/tektoncd-ubuntu-cli.list && \
    sudo apt update && sudo apt install -y tektoncd-cli=v0.20.0

RUN curl -sL https://istio.io/downloadIstioctl | sh - && \
    export PATH=$PATH:$HOME/.istioctl/bin

USER jboss
