#!/bin/bash
#
# This script will stop the terraria server running inside the docker container.
# It will then backup the world files to local system (into the /world folder),
# before destroying the droplet on DigitialOcean. 
#
# NOTE: We are not using `set -e` here, as in a worst-case we still want the 
#       droplet destroyed to prevent un-necessary billing. 

source ./environment_variables.sh

echo "stop terraria docker instance"
docker-machine ssh $DROPLET_NAME "echo -e 'exit\n' | docker attach terraria"

echo "compress remote game files into archive"
docker-machine ssh $DROPLET_NAME tar -czvf /world.tar.gz \
    -C /world .

echo "move archive to local system"
docker-machine scp -r $DROPLET_NAME:/world.tar.gz $PROJECT_DIRECTORY/.

echo "creating a temporary folder"
mkdir -p $PROJECT_DIRECTORY/temp

echo "extracting archive"
tar -xzvf world.tar.gz -C $PROJECT_DIRECTORY/temp

echo "moving game-world files to /world folder"
cp $PROJECT_DIRECTORY/temp/swan_world.twld $PROJECT_DIRECTORY/world/.
cp $PROJECT_DIRECTORY/temp/swan_world.wld $PROJECT_DIRECTORY/world/.

echo "deleting temporary files/folders"
rm -rf temp
rm server_ip.txt
rm world.tar.gz

echo "deleting droplet from DigitalOcean"
docker-machine rm $DROPLET_NAME -y

