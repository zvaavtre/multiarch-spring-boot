FROM ubuntu:noble

# Not building here so only need the jre
RUN export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true \
    && apt -y -q update \
    && apt-get -q install -y openssl openjdk-25-jre \
    && apt -y -q upgrade \
    && apt -y -q clean

# TODO: Should be an arg (or make a little script rather than entrypoint)
ENV JARFILE spring-demo-0.0.1-SNAPSHOT.jar

COPY target/${JARFILE} .

EXPOSE 8080

# Shell form of entrypoint, use docker.env to pass in more configs
ENTRYPOINT java -jar $JARFILE
