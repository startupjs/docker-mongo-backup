FROM mongo:4.4.1

RUN apt-get update && \
    apt-get install -y cron python3 python3-pip && \
    rm -rf /var/lib/apt/lists/*

RUN pip3 install azure-cli

ADD backup.sh /backup.sh
ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh && chmod +x /backup.sh

VOLUME /backup

ENTRYPOINT ["/entrypoint.sh"]
CMD [""]
