FROM artemisian/pidebian-box64

ENV DEBIAN_FRONTEND=noninteractive
# install deps
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y apt-utils && \
    apt-get install -y \
        lib32gcc-s1-amd64-cross \
        libcap-dev \
        libcurl4 \
        libcurl4-openssl-dev \
        tmux \
        jq \
        wget \
	curl \
        procps \
        vim \
    && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*

# steam cmd and directory conf
RUN useradd -ms /bin/bash steam
ENV USER=steam
ENV BASE_DIR=/home
ENV HOME=${BASE_DIR}
ENV SERVER_DIR=${BASE_DIR}/serverfiles

# base dirs
RUN mkdir -p ${BASE_DIR} && \
    mkdir /dayz && \
    groupadd dayz && \
    usermod -a -G dayz steam && \
    mkdir -p ${SERVER_DIR}

# permissions
RUN chown -R steam:dayz ${BASE_DIR} && \
    chown -R steam:dayz /home/steam/ && \
    chown -R steam:dayz /home

# game
EXPOSE 2302/udp
EXPOSE 2303/udp
EXPOSE 2304/udp
EXPOSE 2305/udp
# steam
EXPOSE 8766/udp
EXPOSE 27016/udp
# rcon (preferred)
EXPOSE 2310

WORKDIR ${BASE_DIR}
VOLUME ${BASE_DIR}
COPY config.ini /home/config.ini
COPY serverDZ.cfg /home/serverfiles/serverDZ.cfg
COPY dayzserver.sh /home/dayzserver.sh
RUN chmod -c 666 /home/config.ini
RUN chmod -c 666 /home/serverfiles/serverDZ.cfg
RUN chmod -c 666 /home/dayzserver.sh
USER steam

# reset cmd & define entrypoint
COPY dayzserver.sh /home/dayzserver.sh
CMD ["tail", "-f", "/dev/null"]
