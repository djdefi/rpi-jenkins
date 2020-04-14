FROM arm32v7/openjdk:latest

EXPOSE 8080

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
