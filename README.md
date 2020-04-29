


# Docker

This repository contains the Dockerfile used to run a modded terraria server. 
The Docker instance expects the following environment variables defined on the
host system,

* DISCORD_BOT_TOKEN
* DISCORD_CHANNEL_ID

I've created a bot to relay game chat to a private discord channel. The above
are authentication data needed by the bot. 




This repository is meant to help me setup a terraria game server on digital 
ocean using docker. 

NOTE 2 SELF: Terraria folder on Ubuntu box: ~/.local/share/Terraria

to unset docker-machine locally: 

$ eval "$(docker-machine env -u)"

