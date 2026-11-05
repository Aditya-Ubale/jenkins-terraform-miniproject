# Node.js runtime copied from the official node image (same Debian base as Jenkins)
FROM node:20-bookworm-slim AS node

FROM jenkins/jenkins:lts-jdk17
USER root
RUN apt-get update && apt-get install -y --no-install-recommends unzip curl \
    && rm -rf /var/lib/apt/lists/*
COPY --from=node /usr/local/bin/node /usr/local/bin/node
RUN curl -fsSL https://releases.hashicorp.com/terraform/1.9.8/terraform_1.9.8_linux_amd64.zip -o /tmp/tf.zip \
    && unzip /tmp/tf.zip -d /usr/local/bin && rm /tmp/tf.zip
USER jenkins
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"
ENV CASC_JENKINS_CONFIG=/usr/share/jenkins/ref/casc.yaml
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt
COPY casc.yaml /usr/share/jenkins/ref/casc.yaml
