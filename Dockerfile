ARG NODE_VERSION=16.20.2
#ARG NODE_VERSION=18.20.4
ARG ALPINE_VERSION=3.17.10

FROM node:${NODE_VERSION}-alpine AS node

FROM alpine:${ALPINE_VERSION}

COPY --from=node /usr/lib /usr/lib
COPY --from=node /usr/local/lib /usr/local/lib
COPY --from=node /usr/local/include /usr/local/include
COPY --from=node /usr/local/bin /usr/local/bin

COPY entrypoint.sh /usr/local/bin/

RUN echo 'http://dl-cdn.alpinelinux.org/alpine/v3.9/main' >> /etc/apk/repositories \
 && echo 'http://dl-cdn.alpinelinux.org/alpine/v3.9/community' >> /etc/apk/repositories \
 && apk update \
 && apk add mongodb mongodb-tools openrc git \
 && mkdir /run/openrc \
 && touch /run/openrc/softlevel \
 && chmod u+x,g+x /usr/local/bin/entrypoint.sh \
 && ln -s /usr/local/bin/entrypoint.sh \
 && git clone https://github.com/lukePeavey/quotable.git \
 && git clone https://github.com/Steamrunner/quotable-data.git \
 && echo 'MONGODB_URI=mongodb://localhost' > /quotable/.env \
 && echo 'MONGODB_URI=mongodb://localhost' > /quotable-data/.env \
 && mkdir /generated \
 && cd /quotable-data && npm i && node cli/build \
 && cd /quotable && npm i 

ENV NODE_ENV=development
EXPOSE 4000

ENTRYPOINT ["entrypoint.sh"]
CMD ["sleep", "1000"]
