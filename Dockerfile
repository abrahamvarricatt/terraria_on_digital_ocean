# Docker container which uses Tshock to manage the Terraria server
#
# NOTE: At time of typing, Tshock using terracord is the only way to pass 
#       messages between Terraria and Discord.
#
###############################################################################
FROM ubuntu:bionic-20200403
LABEL description="A docker image to run a Terraria game server"
# We want to use bash shell
SHELL ["/bin/bash", "-c"]  
WORKDIR /usr/src


ENV SERVER_ROOT=/opt/terraria-tshock
ENV SERVER_ZIP=/opt/terraria-tshock-server.zip

# create folders
RUN mkdir -p $SERVER_ROOT

# update repository information
RUN apt-get update -y 

# install dependencies
RUN apt-get install -y \
        wget \
        zip 

# download and extract official server zip
RUN wget -q https://github.com/Pryaxis/TShock/releases/download/v4.4.0-pre6/TShock_4.4.0_Pre6_Terraria1.4.0.3.zip \
         -O $SERVER_ZIP && \
    unzip $SERVER_ZIP -d $SERVER_ROOT && \
    chmod +x $SERVER_ROOT/TerrariaServer.exe

# Expose container port
EXPOSE 7777

# copy entrypoint.sh into container
COPY ./entrypoint.sh .

ENTRYPOINT ["./entrypoint.sh"]
