<!-- vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}: -->
# terraria-docker
# [GitHub](https://github.com/Andy3153/terraria-docker) | [GitLab](https://gitlab.com/Andy3153/terraria-docker)
# Current version: 1.4.3.6

<!-- {{{ BUILD THE IMAGE BY YOURSELF! -->
# BUILD THE IMAGE BY YOURSELF!
I am saying this because:

1. I have no idea how to get `docker buildx` to work right, I'm literally using Docker manifest
1. I don't know how good I'll be at updating my images
1. I switched to an arm64 Raspberry Pi, so I won't provide an `arm32v7` image anymore

***You can still use the images I publish, I just won't guarantee they're the most up-to-date***

In order to easily build your own image, follow [Building the image manually](#building-the-image-manually).
<!-- }}} -->

<!-- {{{ Description -->
## Description
This is a Docker image made to deploy a Terraria server.
<!-- }}} -->

<!-- {{{ Why? -->
## Why?
The reason I made my own Docker image for this is because I want to be able to run it on multiple architectures, like ARM, since I'm personally going to deploy this on my Raspberry Pi. This requires a different approach at the way the server is set up and ran, see the [Terraria Wiki](https://terraria.fandom.com/wiki/Server#How_to_.28RPI_.2F_Others_OSes.29).

This solution provides you with the ability to, theoretically, run this on any architecture that the [Debian Docker container](https://hub.docker.com/_/debian) supports, and on which `mono` is available.
<!-- }}} -->

<!-- {{{ Deployment -->
## Deployment
All of the server data is stored, inside the container, in the folder `/home/terraria`.

<!-- {{{ With docker-compose.yml -->
### With `docker-compose.yml`

<!-- {{{ Downloading the image -->
#### Downloading the image
Here is a very complete `docker-compose.yml` file that downloads the image from my prebuilt images:

```yaml
version: "3.8"

services:
  terraria:
    container_name: terraria
    restart: unless-stopped
    tty: true
    image: andy3153/terraria:latest
    ports:
      - "7777:7777"
    networks:
      net:
        ipv4_address: 172.100.1.100
    volumes:
      - data:/home/terraria
      - /etc/localtime:/etc/localtime:ro

networks:
  net:
    ipam:
      driver: default
      config:
        - subnet: "172.100.1.0/16"

volumes:
  data:
```
<!-- }}} -->

<!-- {{{ Building the image manually -->
#### Building the image manually

<!-- {{{ Is there a new Terraria version? Skip this if not -->
##### Is there a new Terraria version? Skip this if not
If a new Terraria Server version has appeared, you have to modify [line 17 in `setup.sh`](setup.sh#L17).

What you need to do is to change that number to the correct version. The number represents the Terraria's version without the dots in between (ex: '1436' means version 1.4.3.6):

```bash
_terrariaver="1436"
```

So, for example, when 1.4.4 releases, all you have to do is modify that to:

```bash
_terrariaver="144"
```
<!-- }}} -->

<!-- {{{ Building and running the image -->
##### Building and running the image
An easy, copy-paste way of building and running the image is:

```bash
git clone https://github.com/Andy3153/terraria-docker
cd terraria-docker
# ... modify line 17 if new Terraria Server version dropped ... #
docker-compose up -d --build
```
<!-- }}} -->
<!-- }}} -->
<!-- }}} -->

<!-- {{{ Through docker run -->
### Through `docker run`
Here is a couple of short examples you could use to run your Docker container:

<!-- {{{ Minimal -->
#### Minimal:

```bash
docker run -dt \
       --name terraria \
       -p 7777:7777 \
       andy3153/terraria:latest
```
<!-- }}} -->

<!-- {{{ With a volume -->
#### With a volume:

```bash
docker run -dt \
       --name terraria \
       -p 7777:7777 \
       --mount source=terraria,destination=/home/terraria \
       andy3153/terraria:latest
```
<!-- }}} -->

<!-- {{{ The docker-compose.yml translated into a docker run command -->
#### The [`docker-compose.yml`](docker-compose.yml) translated into a `docker run` command:
```bash
# Creating the network
docker network create \
       --driver=default \
       --subnet= 172.100.0.0/16 \
       terraria_net

# Creating the volume
docker volume create terraria_data

# Running the actual Docker container
docker run -dt \
       --name terraria \
       -p 7777:7777 \
       --net terraria_net \
       --ip 172.100.0.100 \
       --mount source=terraria,destination=/home/terraria \
       andy3153/terraria:latest
```
<!-- }}} -->
<!-- }}} -->
<!-- }}} -->

<!-- {{{ File structure inside the volume -->
## File structure inside the volume
After running the container and pointing a volume at the `/home/terraria` folder, you'll see a couple of files and folders inside it. Here are the most important ones:

<!-- {{{ serverconfig.txt -->
### `serverconfig.txt`
This is the Terraria Server's configuration file. Here, you've got details about the used port, the world that will get loaded by default, the settings for autocreating a world etc. In short, this is the file you're going to be most interested in, most likely.
<!-- }}} -->

<!-- {{{ worlds/ -->
### `worlds/`
This folder is the home of all of your worlds. By default, it'll only have a single large world on normal mode, called `world`.
<!-- }}} -->

<!-- {{{ terrariactl -->
### `terrariactl`
This is a shell script that makes it easier to manage the Terraria server.

#### Using the script
Currently it has two options built-in, possibly more to come:

- `start` -- You can use this to start the server automatically, in a Screen session, and it's the way the container is made to start the server upon boot
- `console` -- This attaches you to the Screen session the server is currently running into, allowing you to see the console. To do that, check out [Usage](#usage).
<!-- }}} -->

<!-- {{{ startServer.sh -->
### `startServer.sh`
This contains the command that starts the server. If, for some reason (ex: debugging), you don't want to start the server inside of a Screen session, like with [the `terrariactl` script](#terrariactl), as mentioned above, you can use this directly.
<!-- }}} -->

Other files and folders belong to Terraria Server, you shouldn't (need) to touch those.
<!-- }}} -->

<!-- {{{ Usage -->
## Usage
After the image has been deployed, by default, it is going to generate a large world on normal mode, named `world`. To make any changes, you have to go inside the volume you've created. Locally, on your Docker host, volumes are usually stored in the `/var/lib/docker/volumes` folder.

<!-- {{{ Accessing the server console -->
### Accessing the server console
You can access the Terraria Server's console using a `docker exec` command:

```bash
docker exec -it yourcontainername su terraria -c "terrariactl console"
```

This is going to attach you to the Screen session that the Terraria server is ran inside. In order to close the server, run `exit`. To detach from the Screen session, use `Ctrl+A+D`.
<!-- }}} -->
<!-- }}} -->

<!-- {{{ Contributions -->
## Contributions
I am fully open for contributions of any sort. I am, still, pretty much an intermediate user, regarding Docker, so, any help is going to be welcome.
<!-- }}} -->

<!-- {{{ License -->
## License
[GNU GPLv2](https://www.gnu.org/licenses/old-licenses/gpl-2.0.txt)
<!-- }}} -->
