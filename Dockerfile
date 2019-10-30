FROM nettworksevtooling/eis4d-buildcontainer:latest
MAINTAINER Yves Schumann <yves@eisfair.org>
LABEL Description="This is a base image, which allows connecting Jenkins agents via JNLP protocols"

ARG VERSION=3.35
ARG USER=jenkins
ARG GROUP=jenkins
ARG UID=1058
ARG GID=1007
ARG AGENT_WORKDIR=/home/${USER}/agent
ENV AGENT_WORKDIR=${AGENT_WORKDIR} \
    REPO_DIR=/var/www/html/repo

USER root

COPY jenkins-agent.sh /usr/local/bin/jenkins-agent.sh
RUN groupadd -g ${GID} ${GROUP} \
 && useradd -c "Jenkins user" -d /home/${USER} -u ${UID} -g ${GID} -m ${USER} \
 && apt-get update -y \
 && apt-get install -y \
    openjdk-11-jdk \
 && apt-get clean \
 && curl --create-dirs -fsSLo /usr/share/jenkins/agent.jar https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${VERSION}/remoting-${VERSION}.jar \
      && chmod 755 /usr/share/jenkins \
      && chmod 644 /usr/share/jenkins/agent.jar \
      && ln -sf /usr/share/jenkins/agent.jar /usr/share/jenkins/slave.jar

RUN chmod +x /usr/local/bin/jenkins-agent.sh \
 && chown -R ${UID}:${GID} ${REPO_DIR} \
 && ln -s /usr/local/bin/jenkins-agent.sh /usr/local/bin/jenkins-slave

USER ${USER}

RUN mkdir /home/${USER}/.jenkins \
 && mkdir -p ${AGENT_WORKDIR}

WORKDIR /home/${USER}

ENTRYPOINT ["jenkins-agent.sh"]
