# Use the offical Debian Docker image with a specified version tag, Wheezy, so not all
# versions of Debian images are downloaded.
FROM debian:wheezy

MAINTAINER Seigo Uchida <spesnova@qiita.com>

# Use APT (Advanced Packaging Tool) built in the Linux distro to download Java, a dependency
# to run Minecraft.
RUN DEBIAN_FRONTEND=noninteractive apt-get -y update \
  && DEBIAN_FRONTEND=noninteractive apt-get -y install openjdk-7-jre-headless wget \
  && apt-get clean

# Download Minecraft Server components
RUN wget -q https://s3.amazonaws.com/Minecraft.Download/versions/1.8.7/minecraft_server.1.8.7.jar

# Sets working directory for the CMD instruction (also works for RUN, ENTRYPOINT commands)
# Add config files
# Create mount point, and mark it as holding externally mounted volume
WORKDIR /data
ADD config /data
VOLUME /data/world

# Expose the container's network port: 25565 during runtime.
EXPOSE 25565

# Start Minecraft server
CMD java -jar /minecraft_server.1.8.7.jar
