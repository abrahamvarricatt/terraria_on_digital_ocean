#!/bin/bash
#
# This script will create a new droplet on DigitalOcean and start a terraria
# server on it. It will display the IP of the server before exiting. It will
# also save the IP to a file named `server_ip.txt`. 

set -e  # terminate script if any command fails

source ./environment_variables.sh

echo "creating a temporary directory"
mkdir -p $PROJECT_DIRECTORY/temp

echo "copying game-world files to temp directory"
cp $PROJECT_DIRECTORY/world/swan_world.wld \
   $PROJECT_DIRECTORY/temp/swan_world.wld

echo "compressing temp directory into an archive"
tar -czvf temp.tar.gz -C $PROJECT_DIRECTORY/temp .

echo "deleting temp directory"
rm -rf $PROJECT_DIRECTORY/temp

echo "creating a new droplet on DigitalOcean"
docker-machine create \
    --driver digitalocean \
    --digitalocean-access-token $TERRARIA_DOTOKEN \
    --digitalocean-size $DROPLET_SIZE \
    --digitalocean-image $DROPLET_IMAGE \
    --digitalocean-monitoring=true \
    --digitalocean-region $DROPLET_REGION \
    $DROPLET_NAME

echo "creating a /world directory inside the droplet"
docker-machine ssh $DROPLET_NAME mkdir -p /world

echo "moving archive to remote droplet"
docker-machine scp -r $PROJECT_DIRECTORY/temp.tar.gz $DROPLET_NAME:/.

echo "deleting local copy of archive"
rm temp.tar.gz

echo "uncompressing archive to /world directory"
docker-machine ssh $DROPLET_NAME tar -xzvf /temp.tar.gz -C /world

echo "starting terraria server"
docker-machine ssh $DROPLET_NAME docker run -di \
    --env DISCORD_BOT_TOKEN=$TERRARIA_DISCORD_BOT_TOKEN \
    --env DISCORD_CHANNEL_ID=$TERRARIA_DISCORD_CHANNEL_ID \
    -p 7777:7777 \
    -p 7878:7878 \
    --name terraria \
    --mount src=/world,target=/world,type=bind \
    abrahamvarricatt/modded-terraria-server:latest

echo "saving server IP to file"
docker-machine ip $DROPLET_NAME > server_ip.txt

echo "terraria server is now running on the following IP at port 7777"
docker-machine ip $DROPLET_NAME
