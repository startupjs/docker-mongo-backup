#!/bin/bash

set -e

export MONGO_URI=${MONGO_URI:-mongodb://mongo:27017}

if [[ "$CRON_SCHEDULE" ]]; then
    LOGFIFO='/var/log/cron.fifo'
    if [[ ! -e "$LOGFIFO" ]]; then
        mkfifo "$LOGFIFO"
    fi
    CRON_ENV="MONGO_URI='$MONGO_URI'"
    if [[ "$TARGET_CONTAINER" ]]; then
        CRON_ENV="$CRON_ENV\nTARGET_CONTAINER='$TARGET_CONTAINER'"
    fi
    echo -e "$CRON_ENV\n$CRON_SCHEDULE . $HOME/.profile; /backup.sh > $LOGFIFO 2>&1" | crontab -
    crontab -l
    cron
    tail -f "$LOGFIFO"
else
    exec /backup.sh
fi
