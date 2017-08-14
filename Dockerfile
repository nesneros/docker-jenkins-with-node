FROM jenkins:2.60.2-alpine

USER root

ENV NODE_VERSION=v7.10.0 NPM_VERSION=4 CONFIG_FLAGS="" DEL_PKGS="libstdc++" RM_DIRS=/usr/include

RUN apk add --no-cache bash curl git make gcc g++ python linux-headers binutils-gold gnupg libstdc++ su-exec && \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys \
        94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
        FD3A5288F042B6850C66B31F09FE44734EB7990E \
        71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
        DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
        C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
        B9AE9905FFD7803F25714661B63B535A4C206CA9 \
        56730D5401028683275BD23C23EFEFE93C4CFFFE && \
    curl -sSLO https://nodejs.org/dist/${NODE_VERSION}/node-${NODE_VERSION}.tar.xz && \
    curl -sSL https://nodejs.org/dist/${NODE_VERSION}/SHASUMS256.txt.asc | gpg --batch --decrypt | \
        grep " node-${NODE_VERSION}.tar.xz\$" | sha256sum -c | grep . && \
    tar -xf node-${NODE_VERSION}.tar.xz && \
    cd node-${NODE_VERSION} && \
    ./configure --prefix=/usr ${CONFIG_FLAGS} && \
    make -j$(getconf _NPROCESSORS_ONLN) && \
    make install && \
    cd / && \
    apk del binutils-gold gnupg ${DEL_PKGS} && \
    rm -rf ${RM_DIRS} /node-${NODE_VERSION}* /usr/share/man /tmp/* /var/cache/apk/* \
       /root/.npm /root/.node-gyp /root/.gnupg /usr/lib/node_modules/npm/man \
       /usr/lib/node_modules/npm/doc /usr/lib/node_modules/npm/html /usr/lib/node_modules/npm/scripts

RUN npm install -g yarn
