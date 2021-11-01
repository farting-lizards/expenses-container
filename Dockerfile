FROM docker.io/library/gradle:jdk11
COPY src /src
WORKDIR /src

CMD [ "sh", "-c", "env spring.web.resources.static-locations=file:/src/src/main/resources/static spring.datasource.username=$DB_USERNAME spring.datasource.password=$DB_PASSWORD spring.datasource.url=jdbc:mysql://$DB_HOST:3306/expenses java -jar build/libs/server*SNAPSHOT.jar" ]
