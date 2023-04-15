#!/bin/sh
PHIX_VERSION=$1 && \
    wget http://phix.x10.mx/phix.${PHIX_VERSION}.zip && \
    wget http://phix.x10.mx/phix.${PHIX_VERSION}.1.zip && \
    wget http://phix.x10.mx/phix.${PHIX_VERSION}.2.zip && \
    wget http://phix.x10.mx/phix.${PHIX_VERSION}.3.zip && \
    wget http://phix.x10.mx/phix.${PHIX_VERSION}.4.zip && \
    wget http://phix.x10.mx/p64 && \
    unzip phix.${PHIX_VERSION}.zip -d /usr/local/phix && \
    unzip phix.${PHIX_VERSION}.1.zip -d /usr/local/phix && \
    unzip phix.${PHIX_VERSION}.2.zip -d /usr/local/phix && \
    unzip phix.${PHIX_VERSION}.3.zip -d /usr/local/phix && \
    unzip phix.${PHIX_VERSION}.4.zip -d /usr/local/phix && \
    mv p64 /usr/local/phix/p && \
    chmod +x /usr/local/phix/p && \
    rm -f phix*.zip && \
    printf '#!/bin/sh\n/usr/local/phix/p "$@"\n' >/usr/local/bin/p && \
    chmod +x /usr/local/bin/p
