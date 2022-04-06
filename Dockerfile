FROM mongo:4.4.1

RUN apt-get update && \
    apt-get install -y cron python3 python3-pip curl wget && \
    rm -rf /var/lib/apt/lists/*

#RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

RUN wget -O azcopy_v10.tar.gz https://aka.ms/downloadazcopy-v10-linux && \
    tar -xf azcopy_v10.tar.gz --strip-components=1 && \
    mv azcopy /usr/bin && \
    rm -f azcopy_v10.tar.gz

ADD backup.sh /backup.sh
ADD entrypoint.sh /entrypoint.sh
ADD mongo-cleanup.js /mongo-cleanup.js
RUN chmod +x /entrypoint.sh && chmod +x /backup.sh

VOLUME /backup

ENTRYPOINT ["/entrypoint.sh"]
CMD [""]
