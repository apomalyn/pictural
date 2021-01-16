FROM openjdk:8-jre-alpine

COPY ./build/libs/pictural-server.jar /root/pictural-server.jar

WORKDIR /root

CMD ["java", "-server", "-Xms4g", "-Xmx4g", "-XX:+UseG1GC", "-XX:MaxGCPauseMillis=100", "-XX:+UseStringDeduplication", "-jar", "pictural-server.jar"]