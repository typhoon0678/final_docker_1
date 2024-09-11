# 베이스 이미지
FROM openjdk:17-jdk-bullseye

# Node.js 설치
RUN apt-get install -y curl && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get update && \
    apt-get install -y nodejs && \
    apt-get clean

# git clone
WORKDIR /apps
RUN git clone -b develop https://github.com/ekd594ff/jhta2402_final jhta2402_final

# .git 관리파일 삭제
WORKDIR /apps/jhta2402_final
RUN rm -rf .git

# .env, application.yml 복사
COPY ./.env ./
COPY ./application.yml ./src/main/resources/

# npm install 및 리엑트 빌드파일 생성
WORKDIR /apps/jhta2402_final/frontend
RUN npm install && npm run build

# JAR 파일 빌드 (테스트 생략)
WORKDIR /apps/jhta2402_final
RUN chmod +x gradlew
RUN ./gradlew build -x test

# 애플리케이션 실행
ENTRYPOINT ["java", "-jar", "./build/libs/home-0.0.1-SNAPSHOT.jar"]
