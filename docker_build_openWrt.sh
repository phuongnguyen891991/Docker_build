#!/usr/bin/env bash

CMD=${@:-/bin/bash}

UI_MIRROR_PATH=/home/dat/VEriK/Sunflower/linksys-web-ui
PROJ_DIR=/home/phuong_nguyen/phuong.nguyen/chironWrt/chironv2-openwrt-cloudbasedrouter
CONTAINER_NAME=$(basename $PROJ_DIR)


if [[ $(findmnt -M "$PROJ_DIR/dl") ]]; then
    echo "already mount dl"
else
    echo "Not mounted"
    echo "force remove $PROJ_DIR/dl"
fi

PASSWD_FILE=/etc/passwd
GROUP_FILE=/etc/group
if [[ "$(uname -s)" == "Darwin" ]]; then
    PASSWD_FILE=/private${PASSWD_FILE}
    GROUP_FILE=/private${GROUP_FILE}
fi

CONTAINER_NAME=${USER}_${CONTAINER_NAME}
if [ -z "$(docker ps -a | grep $CONTAINER_NAME)" ]; then
    #--user $(whoami) \
    #-u=$(id -u $(whoami)):$(id -g $(whoami)) \
    docker run -it --rm \
        -u=$(id -u):$(id -g) \
        --volume ${PASSWD_FILE}:/etc/passwd \
        --volume ${GROUP_FILE}:/etc/group \
        --volume ${HOME}:${HOME} \
        --volume /home/workspace:/home/workspace \
        --volume $UI_MIRROR_PATH:/mnt/linksys-web-ui \
        --workdir /mnt/project \
        --name ${CONTAINER_NAME} \
        -v $PROJ_DIR:/mnt/project \
        p3terx/openwrt-build-env:latest $CMD
else
        docker exec -it \
        -u=$(id -u):$(id -g) \
        $CONTAINER_NAME \
        $CMD
fi
