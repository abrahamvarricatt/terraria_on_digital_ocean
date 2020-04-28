#!/bin/bash
#
# This script will create a new droplet on DigitalOcean and start a terraria
# server on it. It will display the IP of the server before exiting. It will
# also save the IP to a file named `server_ip.txt`. 

# set -e  # terminate script if any command fails

source ./environment_variables.sh

echo "stop terraria docker instance"
docker-machine ssh $DROPLET_NAME docker stop terraria

echo "compress remote game files into archive"
docker-machine ssh $DROPLET_NAME tar -czvf /world.tar.gz \
    -C /world .

echo "move archive to local system"
docker-machine scp -r $DROPLET_NAME:/world.tar.gz $PROJECT_DIRECTORY/.

echo "creating a temporary folder"
mkdir -p $PROJECT_DIRECTORY/temp

echo "extracting archive"
tar -xzvf world.tar.gz -C $PROJECT_DIRECTORY/temp

echo "moving gameworld to /world folder"
cp $PROJECT_DIRECTORY/temp/gameworld.wld $PROJECT_DIRECTORY/world/.

echo "deleting temporary files/folders"
rm -rf temp
rm server_ip.txt
rm world.tar.gz

echo "deleting droplet from DigitalOcean"
docker-machine rm $DROPLET_NAME -y

