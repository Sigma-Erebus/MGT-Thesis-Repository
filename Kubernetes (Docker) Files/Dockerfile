FROM debian:stable

ARG HORDE_SERVER_URL

# Install dependencies
RUN apt-get update && apt-get install -y \
    wine \
    xvfb \
    curl \
    unzip \
    sudo \
    ca-certificates

RUN curl https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -o packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN rm packages-microsoft-prod.deb

RUN mkdir -p /home/horde-docker/Horde/Agent && \
    mkdir -p /home/horde-docker/Horde/Logs && \
    mkdir -p /home/horde-docker/Horde/Workspace

RUN --mount=type=secret,id=horde_api_key \
    export HORDE_API_KEY=$(cat /run/secrets/horde_api_key) && \
    curl ${HORDE_SERVER_URL}api/v1/agentsoftware/default/zip -o /home/horde-docker/Horde/HordeAgent.zip -H "Authorization: Bearer $HORDE_API_KEY"
RUN unzip /home/horde-docker/Horde/HordeAgent.zip -d /home/horde-docker/Horde/Agent

RUN apt-get update && apt-get install -y \
    dotnet-runtime-8.0

RUN groupadd --system --gid 443 horde-docker && \
    useradd --system --gid horde-docker --uid 443 --home-dir /home/horde-docker horde-docker && \
    adduser horde-docker sudo && \
    chown -R horde-docker:horde-docker /home/horde-docker

USER horde-docker

COPY entrypoint.sh /entrypoint.sh

WORKDIR /home/horde-docker/Horde

ENTRYPOINT [ "/entrypoint.sh" ]