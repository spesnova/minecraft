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

# Download Spigot Minecraft Server components and some plugins
#
# About Spigot
#   - https://www.spigotmc.org/
#
# About plugins to install:
#   - AutoSaveWorld: http://dev.bukkit.org/bukkit-plugins/autosaveworld/
#   - JoinAndLeaveMessages: https://www.spigotmc.org/resources/join-leave-join-titles-and-configurable-messages.4555/
#   - DynMap: https://www.spigotmc.org/resources/dynmap.274/
RUN wget -q https://getspigot.org/spigot19/spigot_server.jar \
      -O /data/spigot_server.jar \
    && wget -q http://dev.bukkit.org/media/files/859/923/AutoSaveWorld.jar \
      -O /data/plugins/AutoSaveWorld.jar \
    && wget -q http://dynmap.us/builds/dynmap/dynmap-2.3-SNAPSHOT.jar \
      -O /data/plugins/dynmap.jar
# Add downloaded file
# I can only access spigotmc.org with a normal browser,
# because spigotmc.org is protected by CloudfFlare's DDos protecection.
# Also JoinAndLeaveMessages doesn't support spigot 1.9.
#ADD JoinAndLeaveMessages.jar /data/plugins/JoinAndLeaveMessages.jar

# Expose the container's network port: 25565 during runtime.
EXPOSE 25565

# Start Minecraft server
CMD exec java `echo $JVM_OPTS` -jar /data/spigot_server.jar
