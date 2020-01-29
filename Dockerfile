FROM resin/armv7hf-debian-qemu

RUN [ "cross-build-start" ]

EXPOSE 8080

# Get system up to date and install deps.
RUN apt-get update; apt-get --yes upgrade; apt-get --yes install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    default-jre \
    software-properties-common \ 
    libapparmor-dev && \
    apt-get clean && apt-get autoremove -q && \
    rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man /tmp/*

# Setup docker repo
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add - && \
    echo "deb [arch=armhf] https://download.docker.com/linux/debian \
    $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list

ENV JENKINS_HOME /usr/local/jenkins

RUN mkdir -p /usr/local/jenkins
RUN useradd --no-create-home --shell /bin/sh jenkins 
RUN chown -R jenkins:jenkins /usr/local/jenkins/
ADD http://mirrors.jenkins-ci.org/war-stable/latest/jenkins.war /usr/local/jenkins.war
RUN chmod 644 /usr/local/jenkins.war

CMD ["/usr/bin/java", "-jar", "/usr/local/jenkins.war"]

RUN [ "cross-build-end" ]
