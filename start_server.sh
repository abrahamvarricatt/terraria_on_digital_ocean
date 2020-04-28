#!/bin/bash
#
# This script will create a new droplet on DigitalOcean and start a terraria
# server on it. It will display the IP of the server before exiting. It will
# also save the IP to a file named `server_ip.txt`. 

set -e  # terminate script if any command fails

source ./environment_variables.sh

echo "creating a temporary directory"
mkdir -p $PROJECT_DIRECTORY/temp

echo "copying game-world file to temp directory"
cp $PROJECT_DIRECTORY/world/gameworld.wld \
   $PROJECT_DIRECTORY/temp/gameworld.wld

echo "copying all configs to temp directory"
cp -r $PROJECT_DIRECTORY/config/* $PROJECT_DIRECTORY/temp/.

echo "compressing temp directory into an archive"
tar -czvf temp.tar.gz -C $PROJECT_DIRECTORY/temp .

echo "deleting temp directory"
rm -rf $PROJECT_DIRECTORY/temp

echo "creating a new droplet on DigitalOcean"
docker-machine create \
	--driver digitalocean \
	--digitalocean-access-token $DOTOKEN \
	--digitalocean-size $DROPLET_SIZE \
	--digitalocean-image $DROPLET_IMAGE \
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
docker-machine ssh $DROPLET_NAME docker run -dit \
    -p 7777:7777 \
    --mount src=/world,target=/world,type=bind \
    --name="terraria" ryshe/terraria:latest \
    -world /world/gameworld.wld

echo "saving server IP to file"
docker-machine ip $DROPLET_NAME > server_ip.txt

echo "terraria server is now running on the following IP at port 7777"
docker-machine ip $DROPLET_NAME
