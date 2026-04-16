
# Stage 1: Build với Maven và Java 21
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app

# Copy pom.xml và tải dependencies trước (để tận dụng cache của Docker)
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy source code và build
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Runtime
FROM eclipse-temurin:21-jre-jammy
WORKDIR /app

# Copy file jar từ stage build sang (tên file jar lấy từ pom.xml)
COPY --from=build /app/target/discovery-service-0.0.1-SNAPSHOT.jar app.jar

# Port 8761 của Eureka
EXPOSE 8761

ENTRYPOINT ["java", "-jar", "app.jar"]