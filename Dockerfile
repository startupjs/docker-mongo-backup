FROM ubuntu:18.04
LABEL Description="Mongodb cron backup to Google Cloud Storage (GCE)"

RUN apt-get update && \
  apt-get install -y software-properties-common curl wget

RUN wget https://fastdl.mongodb.org/tools/db/mongodb-database-tools-ubuntu1804-x86_64-100.3.0.deb -P /tmp && \
    dpkg -i /tmp/mongodb-database-tools-ubuntu1804-x86_64-100.3.0.deb

RUN apt-get install -y python-pip && pip install devcron

RUN mkdir /cron && \
    echo "* * * * * /cron/sample.sh" > /cron/crontab && \
    echo "echo hello world" > /cron/sample.sh && \
    chmod a+x /cron/sample.sh

RUN curl -s -O https://storage.googleapis.com/pub/gsutil.tar.gz && \
  tar xfz gsutil.tar.gz -C $HOME && \
  chmod 777 /root/gsutil && chmod 777 /root/gsutil/* && \
  rm gsutil.tar.gz

ENV CRON_TIME "0 1 * * *"

COPY ./send-notification.sh /
RUN chmod +x /send-notification.sh

COPY ./mongodb-backup.sh /
RUN chmod +x /mongodb-backup.sh

COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
