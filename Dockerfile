# Start with a base image containing Java runtime
FROM openjdk:8-jdk-alpine

# Add Maintainer Info
LABEL maintainer="pamenon@redhat.com"

# Make port 8090 available to the world outside this container
EXPOSE 8090
RUN mkdir /deployments
# Install KJAR
RUN mkdir -p /.m2/repository/com/company/pam-poc-kjar/1.0-SNAPSHOT
ADD pam-poc-kjar-1.0-SNAPSHOT.jar /.m2/repository/com/company/pam-poc-kjar/1.0-SNAPSHOT/
ADD pam-poc-kjar-1.0-SNAPSHOT.pom /.m2/repository/com/company/pam-poc-kjar/1.0-SNAPSHOT/

# Add the spring-boot-kie-server jar to the container
ADD target/pam-poc-service-1.0-SNAPSHOT.jar /deployments/pam-poc-service-1.0-SNAPSHOT.jar
# kie-server state file
ADD sample-kie-server-monitor-id.xml /deployments/sample-kie-server-monitor-id.xml

# openshift permission nonsense to fix arjuna jTA crap
RUN chown -R 1001:0 /deployments && chmod -R a+rx,g+rwx /deployments
USER 1001
WORKDIR /deployments
ENTRYPOINT ["java","-Dorg.kie.server.startup.strategy=LocalContainersStartupStrategy","-Dorg.kie.server.controller.user=kieserver","-Dorg.kie.server.controller.password=kieserver1!","-Dorg.kie.server.mode=development","-Dorg.kie.prometheus.server.ext.disabled=false","-jar","pam-poc-service-1.0-SNAPSHOT.jar"]