# Build stage
FROM maven:3.9.5-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src ./src
RUN mvn clean package -DskipTests

# Run stage
FROM tomcat:10.1-jdk17
RUN rm -rf /usr/local/tomcat/webapps/ROOT
COPY --from=build /app/target/craverush-1.0.0.war /usr/local/tomcat/webapps/ROOT.war

# Create startup script that injects PORT at runtime
RUN echo '#!/bin/bash\n\
PORT=${PORT:-8080}\n\
sed -i "s/port=\"8080\"/port=\"${PORT}\"/g" /usr/local/tomcat/conf/server.xml\n\
exec catalina.sh run' > /start.sh && chmod +x /start.sh

EXPOSE 8080
CMD ["/start.sh"]
