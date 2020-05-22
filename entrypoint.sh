#!/bin/bash

COMMAND=$1

# Substitute data within XML files
sed -i "s/DISCORD_BOT_TOKEN/$DISCORD_BOT_TOKEN/g" "$CONFIGPATH/TerrariaChatRelay/TerrariaChatRelay-Discord.json"
sed -i "s/DISCORD_CHANNEL_ID/$DISCORD_CHANNEL_ID/g" "$CONFIGPATH/TerrariaChatRelay/TerrariaChatRelay-Discord.json"


if [ -z "$COMMAND" ]; then
    # COMMAND is empty, means we need to start the game-server
    cd $SERVER_ROOT
    echo "Loading to world $WORLD_FILENAME..."
    mono --server --gc=sgen -O=all TerrariaServer.exe \
           -configPath "$CONFIGPATH" \
           -logpath "$LOGPATH" \
           -world "$WORLD_PATH"
else
    # we got a command, execute it!
    exec $COMMAND
fi
