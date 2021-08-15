FROM --platform=arm64 docker.io/library/gradle:jdk11
COPY src /src
WORKDIR /src
CMD ["gradle", "bootRun"]
