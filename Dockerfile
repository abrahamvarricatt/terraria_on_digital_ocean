# Docker container which uses Tshock to manage the Terraria server
#
# NOTE: At time of typing, Tshock using terracord is the only way to pass 
#       messages between Terraria and Discord.
#
###############################################################################
FROM mono:6.8.0.96
LABEL description="A docker image to run a Terraria game server"
# We want to use bash shell
SHELL ["/bin/bash", "-c"]  
WORKDIR /usr/src


ENV SERVER_ROOT=/opt/terraria-tshock
ENV SERVER_ZIP=/opt/terraria-tshock-server.zip
ENV TCR_ZIP=/opt/TerrariaChatRelay.zip
ENV WORLD_FILENAME=swan_world.wld
ENV CONFIGPATH=/opt/tshock-config
ENV WORLD_PATH=/world/$WORLD_FILENAME
ENV LOGPATH=/world/tshock-logs


# create folders
RUN mkdir -p $SERVER_ROOT \
             $LOGPATH \
             $CONFIGPATH

# update repository information
RUN apt-get update -y 

# install dependencies
RUN apt-get install -y \
        wget \
        zip 

# download and extract Tshock
RUN wget -q https://github.com/Pryaxis/TShock/releases/download/v4.4.0-pre6/TShock_4.4.0_Pre6_Terraria1.4.0.3.zip \
         -O $SERVER_ZIP && \
    unzip $SERVER_ZIP -d $SERVER_ROOT && \
    chmod +x $SERVER_ROOT/TerrariaServer.exe

# download Terraria Chat Relay
RUN wget -q https://github.com/xPanini/TCR-TerrariaChatRelay-TShock/releases/download/0.9.1.1/TerrariaChatRelay-TShock-0.9.1.1.zip \
         -O $TCR_ZIP && \
    unzip $TCR_ZIP -d $SERVER_ROOT/ServerPlugins

# Expose container port
EXPOSE 7777

# Expose REST endpoints
EXPOSE 7878

# Copy config files to container
COPY ./config $CONFIGPATH

# copy entrypoint.sh into container
COPY ./entrypoint.sh .

ENTRYPOINT ["./entrypoint.sh"]
