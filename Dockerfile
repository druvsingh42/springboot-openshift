# Start with a base image containing Java runtime
#FROM openjdk:8-jdk-alpine

# Add Maintainer Info
#LABEL maintainer="Testing"

# Add a volume pointing to /tmp
#VOLUME /tmp

# Make port 8080 available to the world outside this container
#EXPOSE 8080

# The application's jar file
#ARG JAR_FILE=target/springboot-kubernetes-v3-0.0.1-SNAPSHOT.jar

# Add the application's jar to the container
#ADD ${JAR_FILE} springboot-kubernetes-v3.jar

# Run the jar file
#ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/springboot-kubernetes-v3.jar"]


# A Java 8 runtime example
# The official Red Hat registry and the base image
FROM registry.access.redhat.com/rhel7-minimal
USER root
# Install Java runtime
RUN microdnf --enablerepo=rhel-7-server-rpms \
install java-1.8.0-openjdk --nodocs ;\
microdnf clean all
# Set the JAVA_HOME variable to make it clear where Java is located
ENV JAVA_HOME /etc/alternatives/jre
# Dir for my app
RUN mkdir -p /app
# Expose port to listen to
EXPOSE 8080
# Copy the MicroProfile starter app
COPY springboot-kubernetes-v4.jar /app/
# Copy the script from the source; run-java.sh has specific parameters to run a Thorntail app from the command line in a container. More on the script can be found at https://github.com/sshaaf/rhel7-jre-image/blob/master/run-java.sh
COPY run-java.sh /app/
# Setting up permissions for the script to run
RUN chmod 755 /app/run-java.sh
# Finally, run the script
CMD [ "/app/run-java.sh" ]
