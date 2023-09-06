FROM openjdk:18
WORKDIR /app
COPY /harness/sampleapp/spring-boot-web-application/target/student-services-security-0.0.1-SNAPSHOT.jar /app
EXPOSE 8080

CMD ["java", "-jar", "student-services-security-0.0.1-SNAPSHOT.jar"]