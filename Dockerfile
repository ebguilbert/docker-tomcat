FROM openjdk:11-slim

LABEL maintainer="Edwin Guilbert"

# ENV variables for Tomcat
ENV TOMCAT_MAJOR 9
ENV TOMCAT_VERSION 9.0.54
ENV CATALINA_HOME /opt/tomcat
ENV CATALINA_TMPDIR /tmp/tomcat
ENV DEPLOYMENT_DIR $CATALINA_HOME/webapps
ENV PATH $PATH:$CATALINA_HOME/bin:$CATALINA_HOME/scripts

# Install Tomcat
RUN apt-get update; \
	apt-get install -y --no-install-recommends \
    wget \
    curl


RUN wget -q https://www.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR}/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz && \
    tar -xf apache-tomcat-${TOMCAT_VERSION}.tar.gz && \
    rm apache-tomcat*.tar.gz && \
    mv apache-tomcat* ${CATALINA_HOME}

RUN chmod +x ${CATALINA_HOME}/bin/*sh

# Fix for JVM core dump
RUN ulimit -c unlimited

# Make sure that the temporary directory exists
RUN mkdir -p $CATALINA_TMPDIR

# Remove all webapps from the default Tomcat installation
RUN rm -rf $DEPLOYMENT_DIR/*

# Start the Tomcat instance
ENTRYPOINT ["/opt/tomcat/bin/catalina.sh", "run"]
CMD [""]

# Expose the ports
EXPOSE 8080