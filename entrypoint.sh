#!/bin/bash

COMMAND=$1

if [ -z "$COMMAND" ]; then
    # COMMAND is empty, means we need to start the game-server
    cd $SERVER_ROOT
    # ./TerrariaServer -autoarch \
    #                  -config $SERVER_CONFIG \
    #                  -name 'my-terraria' \
    #                  -world $CONFIG_ROOT/worlds/gameworld.wld
    ./tModLoaderServer -name 'my-terraria' \
                       -world $TMODLOADER_ROOT/Worlds/swan_world.wld
else
    # we got a command, execute it!
    exec $COMMAND
fi

# ./TerrariaServer -x64 -config server.conf | \
#     tee /var/log/terraria/$(date +"%m_%d_%Y").log
