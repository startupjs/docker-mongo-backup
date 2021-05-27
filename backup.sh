#!/bin/bash

set -eo pipefail

echo "Job started: $(date)"

DATE=$(date +%Y%m%d_%H%M%S)

if [[ -z "$TARGET_CONTAINER" ]]; then
    >&2 echo "If TARGET_FOLDER is null/unset, TARGET_CONTAINER must be set"
    exit 1
fi

/usr/local/bin/az storage blob upload -f /dev/fd/0 -c ${TARGET_CONTAINER} -n "backup-$DATE.tar.gz" < mongodump --uri "$MONGO_URI" --gzip --archive

echo "Mongo dump uploaded to $TARGET_CONTAINER"

echo "Job finished: $(date)"
