FROM nettworksevtooling/eis4d-buildcontainer:latest
MAINTAINER Yves Schumann <yves@eisfair.org>
LABEL Description="This is a base image, which allows connecting Jenkins agents via JNLP protocols"

ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000
ARG AGENT_WORKDIR=/home/${user}/agent
ENV AGENT_WORKDIR=${AGENT_WORKDIR}

USER root

COPY jenkins-agent.sh /usr/local/bin/jenkins-agent.sh
RUN groupadd -g ${gid} ${group} \
 && useradd -c "Jenkins user" -d /home/${user} -u ${uid} -g ${gid} -m ${user} \
 && apt-get update -y \
 && apt-get install -y \
    openjdk-11-jdk \
 && apt-get clean \
 && curl --create-dirs -fsSLo /usr/share/jenkins/agent.jar https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${VERSION}/remoting-${VERSION}.jar \
      && chmod 755 /usr/share/jenkins \
      && chmod 644 /usr/share/jenkins/agent.jar \
      && ln -sf /usr/share/jenkins/agent.jar /usr/share/jenkins/slave.jar

RUN chmod +x /usr/local/bin/jenkins-agent.sh \
 && ln -s /usr/local/bin/jenkins-agent.sh /usr/local/bin/jenkins-slave

USER ${user}

RUN mkdir /home/${user}/.jenkins \
 && mkdir -p ${AGENT_WORKDIR}

VOLUME /home/${user}/.jenkins
VOLUME ${AGENT_WORKDIR}
WORKDIR /home/${user}

ENTRYPOINT ["jenkins-agent.sh"]
