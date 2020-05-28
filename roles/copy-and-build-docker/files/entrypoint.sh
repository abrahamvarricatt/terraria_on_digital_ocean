#!/bin/bash

COMMAND=$1

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
