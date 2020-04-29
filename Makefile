#
#
#
#


start-server:
	docker-machine create \
	--driver digitalocean \
	--digitalocean-access-token $(DOTOKEN) \
	--digitalocean-size s-2vcpu-4gb \
	--digitalocean-image ubuntu-18-04-x64 \
	terraria-server

stop-server:
	docker-machine rm terraria-server -y

connect-client:
	docker-machine env terraria-server && \
	eval $(docker-machine env terraria-server)

start-game:
	docker-machine ssh terraria-server mkdir -p /world && \
	docker run -it -p 7777:7777 \
	--mount src="/world",target=/world,type=bind \
	--name="terraria" \
	ryshe/terraria:latest

docker-build:
	docker build --tag abrahamvarricatt/modded-terraria-server .

docker-push:
	docker push abrahamvarricatt/modded-terraria-server
	
docker-shell:
	docker run --rm \
			   --env DISCORD_BOT_TOKEN \
			   --env DISCORD_CHANNEL_ID \
			   --mount src="$(shell pwd)/world",target=/world,type=bind \
			   -it \
			   -p 7777:7777 \
			   abrahamvarricatt/modded-terraria-server /bin/bash

docker-game:
	docker run --rm \
			   --env DISCORD_BOT_TOKEN \
			   --env DISCORD_CHANNEL_ID \
			   --mount src="$(shell pwd)/world",target=/world,type=bind \
			   -it \
			   -p 7777:7777 \
			   abrahamvarricatt/modded-terraria-server

