
# Introduction

There are 2 ways to look at this project,

1. It has a Dockerfile which is setup to run a Terraria game server with a few 
 mods (notably a Discord chat mod)
2. It contains scripts to deploy a droplet on DigitalOcean running the 
 previously mentioned Dockerfile as well as scripts to destroy the droplet.
  * NOTE: The scripts will load/save the game-world from/to the host system 
    running the scripts.


# Docker image

While the Dockerfile is present in this repository, the expectation is that 
after the image is built, it will be pushed online and be publicly accessible 
from Docker Hub. This will save time when creating the Droplet. 


# Deployment scripts

### start_server.sh
Creates a new droplet named 'terraria-server' on Digital Ocean, instantiates 
the Docker container and writes the IP of the server to a file named 
server_ip.txt. Running this script, even after the droplet is created is 
designed to be harmless. 

### stop_server.sh
Creates a backup of the game world to host system and destroys the droplet 
named 'terraria-server' from Digital Ocean. Running this script when the 
droplet is not present is designed to be harmless.

