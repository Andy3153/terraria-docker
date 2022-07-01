<!-- vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}: -->
# terraria-docker

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
All of the server data is stored, inside the container, in the folder `/home/terraria`. If you want to only get the worlds inside a volume, use the folder `/home/terraria/worlds` (this'll exclude your server configuration file)

<!-- {{{ With docker-compose.yml -->
## With `docker-compose.yml`
Here is a very complete `docker-compose.yml` file that builds the image.

```yaml
version: "3.8"

services:
  terraria:
    container_name: terraria
    restart: always
    tty: true
    build: .
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

<!-- {{{ Through docker run -->
### Through `docker run`
Here is a couple of short examples you could use to run your Docker container:

- Minimal:

```bash
docker run -dt \
       --name terraria \
       -p 7777:7777 \
       terrariaimage
```

- With a volume:

```bash
docker run -dt \
       --name terraria \
       -p 7777:7777 \
       --mount source=terraria,destination=/home/terraria \
       terrariaimage
```

- The `docker-conpose.yml` translated into a `docker run` command:
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
       terrariaimage
```
<!-- }}} -->
<!-- }}} -->

<!-- {{{ Usage -->
## Usage
After the image has been deployed, you can access the Terraria server's console using a `docker exec` command:

```bash
docker exec -it yourcontainername su terraria -c "terrariactl console"
```

This is going to attach you to the Screen session that the Terraria server is ran inside. In order to close the server, run `exit`. To detach from the Screen session, use `Ctrl+A+D`.
<!-- }}} -->
