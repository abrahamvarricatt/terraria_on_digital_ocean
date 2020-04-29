
# Hosting on DigitalOcean

This repository contains scripts which can be used to create and destroy 
temporary droplets (linux hosts) on DigitalOcean to physically run the modded 
terraria server. These scripts expect the following environment variables to be
defined on the host system,

* DOTOKEN
* DISCORD_BOT_TOKEN
* DISCORD_CHANNEL_ID

This project was built assuming you have `docker` and `docker-machine` installed
on the host system. Refer to,

https://blog.abraham-v.com/articles/2020/002-installing-docker-and-docker-machine.html

for instructions on how to install those tools. 


## Script usage

### Prerequisites

* Instructions assume host is an Ubuntu 18.04 LTS system
* Make sure you have `docker` and `docker-machine` installed
* Clone this repository to your local system (we'll call this host)
* Copy game files named `swan_world.twld` and `swan_world.wld` into the `/world`
  folder. You can create these files as a new world with Terraria running 
  tModloader.
* Make sure the environment variables mentioned in the previous section are 
  accessable. I suggest saving them into the user's `.bashrc` or `.zshrc` files.


### Starting the server

Just run the script,

```
$ ./start_server.sh
```
 
At a high level here is what the script does,

* Creates a new droplet on DigitalOcean
* Installs and starts a Terraria server with tModloader inside a docker
  instance
* The game world used is the one found in `/world` folder (NOTE: The name of the
  files *must* be `swan_world.*`!)
* It downloads 3 mods and installs them = a discord relay, a recipe browser and
  boss checklist
* Before the script finishes, it will print the IP of the droplet as well as 
  write this into a `server_ip.txt` file. 


### Joining the host

From your local system, you can start Terraria with tModloader and connect to
the IP reported (it uses default port 7777). When the game connects, it will
automatically synchronize the mods to the local system. You can visit,

https://www.tmodloader.net

for instructions on how to install the modding tool. For the most part it is a
matter of extracting files to the Terraria game folder. 

Pressing "Enter" in-game will open the chat window. Any chatter mentioned here
will get echoed on the connected Discord channel. :D 


### Stopping the server

Running the following script will stop the server,

```
$ ./stop_server.sh
```

At a high leve here is what happens,

* an `exit` command is sent to the game server to stop and save the state of the
  game world
* the game world will be copied to the local system and stored into the `/world`
  folder
* the droplet on DigitalOcean will be destroyed (Thus, no more billing! Yay!)







# Docker

This repository contains the Dockerfile used to run a modded terraria server. 
The Docker instance expects the following environment variables defined on the
host system,

* DISCORD_BOT_TOKEN
* DISCORD_CHANNEL_ID

I've created a bot to relay game chat to a private discord channel. The above
are authentication data needed by the bot. 

## Building and updating the docker image on Docker Hub

After cloning this repository, you can build the docker image by running the
following command,

```
$ make docker-build
```

Once the image is built, it can be pused to docker hub using,

```
$ make docker-push
```

NOTE: You will need to be logged into docker for the above to work. Run 
`$ docker login` if needed. 

