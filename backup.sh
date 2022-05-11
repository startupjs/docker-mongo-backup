#!/bin/bash
set -eo pipefail

#source $HOME/.profile

echo "Job started: $(date)"

DATE=$(date +%Y%m%d_%H%M%S)

if [[ -z "$TARGET_CONTAINER" ]]; then
    >&2 echo "If TARGET_FOLDER is null/unset, TARGET_CONTAINER must be set"
    exit 1
fi

# MONGO_DATABASE='mydb db2 newdb' overwrite it if required
if [[ -z "$MONGO_DATABASE" ]]; then
    echo "MONGO_DATABASE is unset or set to the empty string"
    MONGO_DATABASE=`mongo $MONGO_URI --quiet --eval "db.getMongo().getDBNames()" | grep '"' | tr -d '",\n' | sed s/"config"//`
fi
echo "backing up dbs: ${MONGO_DATABASE}"

#/usr/bin/az login --identity
/usr/bin/azcopy login --identity

for DB_NAME in ${MONGO_DATABASE}
do

echo "cleaning up ${DB_NAME}"

mongo "mongodb://${MONGO_HOST}/${DB_NAME}?readPreference=primary" /mongo-cleanup.js

echo "backing up ${DB_NAME}"

/usr/bin/mongodump --uri "${MONGO_URI}" -d "${DB_NAME}" -o ${DB_NAME}-$DATE --numParallelCollections=1
tar -cvzf ${DB_NAME}-$DATE.tar.gz ${DB_NAME}-$DATE --remove-files
#/usr/bin/az storage blob upload -f ${DB_NAME}-$DATE.tar.gz -c ${TARGET_CONTAINER} -n "${DB_NAME}-$DATE.tar.gz"

/usr/bin/azcopy cp ${DB_NAME}-$DATE.tar.gz https://${AZURE_STORAGE_ACCOUNT}.blob.core.windows.net/${TARGET_CONTAINER}/${DB_NAME}-$DATE.tar.gz

echo "Mongo dump uploaded to $TARGET_CONTAINER"

rm ${DB_NAME}-$DATE.tar.gz

done

echo "Job finished: $(date)"