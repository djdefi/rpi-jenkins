FROM resin/armv7hf-debian-qemu:latest

RUN [ "cross-build-start" ]

EXPOSE 8080

RUN echo "deb http://archive.debian.org/debian jessie-backports main" > /etc/apt/sources.list.d/jessie-backports.list

# Get system up to date and install deps.
RUN mkdir -p /usr/share/man/man1mkdir -p /usr/share/man/man1 && \
    apt-get update; apt-get --yes upgrade; \
    apt install --yes -t jessie-backports openjdk-8-jre-headless ca-certificates-java; \
    apt-get --yes install \
    java-common \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common \ 
    libapparmor-dev && \
    apt-get clean && apt-get autoremove -q && \
    rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man /tmp/*

# Setup docker repo
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add - && \
    echo "deb [arch=armhf] https://download.docker.com/linux/debian \
    $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list

RUN ls -l /usr/lib/jvm/ 
RUN /usr/sbin/update-java-alternatives -s java-1.8.0-openjdk-armhf

ENV JENKINS_HOME /usr/local/jenkins

RUN mkdir -p /usr/local/jenkins
RUN useradd --no-create-home --shell /bin/sh jenkins 
RUN chown -R jenkins:jenkins /usr/local/jenkins/
ADD http://mirrors.jenkins-ci.org/war-stable/latest/jenkins.war /usr/local/jenkins.war
RUN chmod 644 /usr/local/jenkins.war

CMD ["/usr/bin/java", "-jar", "/usr/local/jenkins.war"]

RUN [ "cross-build-end" ]
