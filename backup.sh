#!/bin/bash

set -eo pipefail

source $HOME/.profile

echo "Job started: $(date)"

DATE=$(date +%Y%m%d_%H%M%S)

if [[ -z "$TARGET_CONTAINER" ]]; then
    >&2 echo "If TARGET_FOLDER is null/unset, TARGET_CONTAINER must be set"
    exit 1
fi

/usr/bin/az login --identity

/usr/bin/mongodump --uri "$MONGO_URI" --gzip --archive=backup-$DATE.tar.gz

/usr/bin/az storage blob upload -f backup-$DATE.tar.gz -c ${TARGET_CONTAINER} -n "backup-$DATE.tar.gz"

echo "Mongo dump uploaded to $TARGET_CONTAINER"

rm backup-$DATE.tar.gz

echo "Job finished: $(date)"
