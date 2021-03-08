#!/bin/bash

source ./send-notification.sh

# Settings
PROJECT_ID="$PROJECT_ID"
DB_HOST="$MONGO_HOST"
DB_USER="$MONGO_USER"
DB_PASS="$MONGO_PASS"
BUCKET_NAME="$BUCKET"
AUTHDB="$AUTHDB"

# Path in which to create the backup (will get cleaned later)
BACKUP_PATH="/tmp/dump/"

CURRENT_DATE=$(date +"%Y%m%d-%H%M")

# Backup filename
BACKUP_FILENAME="$DB_NAME-$CURRENT_DATE.tar.gz"

# Create the backup
if [ -z "$DB_PASS" ]; then
  mongodump -h "$DB_HOST" -o "$BACKUP_PATH" || send_notification "DB Backup failed on $PROJECT_ID/$DB_NAME"
else
  mongodump -h "$DB_HOST" -u "$DB_USER" -p "$DB_PASS" -o "$BACKUP_PATH" --authenticationDatabase="$AUTHDB" || send_notification "DB Backup failed on $PROJECT_ID/$DB_NAME"
fi
cd $BACKUP_PATH || exit

# Archive and compress
tar -cvzf "$BACKUP_PATH""$BACKUP_FILENAME" ./*

# Copy to Google Cloud Storage
echo "Copying $BACKUP_PATH$BACKUP_FILENAME to gs://$BUCKET_NAME/$DB_NAME/"
/root/gsutil/gsutil cp "$BACKUP_PATH""$BACKUP_FILENAME" gs://"$BUCKET_NAME"/"$DB_NAME"/ 2>&1
echo "Copying finished"
echo "Removing backup data"
rm -rf $BACKUP_PATH*
