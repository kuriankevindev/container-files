FROM openjdk:8-slim

ARG USER=juser
ARG UID=1000
ARG GID=1000
ARG PW=juser

RUN useradd -m ${USER} --uid=${UID} \
	&& echo "${USER}:${PW}" | chpasswd

USER ${UID}:${GID}
WORKDIR /home/${USER}

COPY employee-spring-1.0.0.jar runtime/

CMD ["java", "-jar", "runtime/employee-spring-1.0.0.jar"]
