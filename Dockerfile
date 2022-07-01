# vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
FROM debian:stable-slim

LABEL maintainer="Andrei Dobrete (github.com/Andy3153 | gitlab.com/Andy3153)"
LABEL Description="Docker image for Terraria Server"

COPY setup.sh /
COPY terrariactl /
COPY startServer.sh /

COPY serverconfig.txt /

# Getting Terraria Server
RUN /setup.sh

CMD su terraria -c "terrariactl start"
