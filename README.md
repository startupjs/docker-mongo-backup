azure/mongodump
===================

Docker image with `mongodump`, `cron` and AZ CLI to upload backups to AZ BLOB STORAGE.

### Environment variables

| Env var               | Description | Default                 |
|-----------------------|-------------|-------------------------|
| `MONGO_URI`             | Mongo URI.  | `mongodb://mongo:27017` |
| `CRON_SCHEDULE`         | Cron schedule. Leave empty to disable cron job. | `''` |
| `TARGET_CONTAINER`      | Azure blob container to upload backups. | `''` |