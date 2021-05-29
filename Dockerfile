FROM mongo:4.4.1

RUN apt-get update && \
    apt-get install -y cron python3 python3-pip curl && \
    rm -rf /var/lib/apt/lists/*

RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

ADD backup.sh /backup.sh
ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh && chmod +x /backup.sh

VOLUME /backup

ENTRYPOINT ["/entrypoint.sh"]
CMD [""]
