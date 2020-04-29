#!/bin/bash

COMMAND=$1

# We need to update the TerrariaChatRelay-Discord.json file with values from
# environment variables, so first check that the environment varaibles exist,
# and if they do not, fill in some defaults
if [[ -z "${DISCORD_BOT_TOKEN}" ]]; then
  export DISCORD_BOT_TOKEN="no-token-found"
fi
if [[ -z "${DISCORD_CHANNEL_ID}" ]]; then
  export DISCORD_CHANNEL_ID=0
fi

# Substitute data within the JSON files
sed -i "s/DISCORD_BOT_TOKEN/$DISCORD_BOT_TOKEN/g" "$TMODLOADER_ROOT_MOD_CONFIGS/TerrariaChatRelay/TerrariaChatRelay-Discord.json"
sed -i "s/DISCORD_CHANNEL_ID/$DISCORD_CHANNEL_ID/g" "$TMODLOADER_ROOT_MOD_CONFIGS/TerrariaChatRelay/TerrariaChatRelay-Discord.json"


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
