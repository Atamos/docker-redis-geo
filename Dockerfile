 FROM debian:wheezy

RUN groupadd -r redis && useradd -r -g redis redis
    
RUN apt-get update \
&& apt-get install -y curl \
&& rm -rf /var/lib/apt/lists/*

RUN gpg --keyserver pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
RUN curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture)" \
&& curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture).asc" \
&& gpg --verify /usr/local/bin/gosu.asc \
&& rm /usr/local/bin/gosu.asc \
&& chmod +x /usr/local/bin/gosu

RUN buildDeps='gcc libc6-dev libyajl-dev cmake make git '; \
set -x \
&& apt-get update && apt-get install -y $buildDeps --no-install-recommends \
&& rm -rf /var/lib/apt/lists/* 

RUN mkdir -p /usr/src
WORKDIR /usr/src

RUN git clone https://github.com/mattsta/redis \
    && cd redis \
    && git checkout dynamic-redis-unstable \
    && cd deps \
    && make lua hiredis linenoise jemalloc \
    && cd .. \
    && make \ 
    && make install 

RUN cd /usr/src \
    && git clone https://github.com/lloyd/yajl \
    && cd yajl \
    && ./configure \
    && make

RUN cd /usr/src \
    && git clone https://github.com/mattsta/krmt \ 
    && cd krmt \
    && make -j \
    && cp *.so /usr/lib/


#RUN cd / && ln -s redis-server "$(dirname "$(which redis-server)")/redis-sentinel"

RUN mkdir /data && chown redis:redis /data
VOLUME /data
WORKDIR /data

EXPOSE 6379

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]

CMD [ "redis-server" ]
