FROM ubuntu:trusty

MAINTAINER Seigo Uchida <spesnova@qiita.com>

# Use APT (Advanced Packaging Tool) built in the Linux distro to download Java,
# a dependency to run Minecraft.
RUN DEBIAN_FRONTEND=noninteractive apt-get -y update \
  && DEBIAN_FRONTEND=noninteractive apt-get -y install openjdk-7-jre-headless wget openssl \
  && apt-get clean

ADD /data /data
VOLUME /data/world
VOLUME /data/world_nether
VOLUME /data/world_the_end

WORKDIR /data

# Download Spigot Minecraft Server components
RUN wget -q https://getspigot.org/spigot18/spigot_server.jar

# Expose the container's network port: 25565 during runtime.
EXPOSE 25565

# Start Minecraft server
CMD java `echo $JVM_OPTS` -jar /data/spigot_server.jar
