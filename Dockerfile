FROM tomcat:9.0-jdk21-temurin

RUN rm -rf /usr/local/tomcat/webapps/*

COPY . /usr/local/tomcat/webapps/siakad/

EXPOSE 8080

CMD ["catalina.sh", "run"]