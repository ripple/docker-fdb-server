FROM fdb-client

RUN apt-get update && apt-get install -y --no-install-recommends \
      python \
      python-setuptools \
 && easy_install supervisor && mkdir -p /var/log/supervisor \
 && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/foundationdb && touch /etc/foundationdb/fdb.cluster \
 && curl -SLO "https://foundationdb.com/downloads/I_accept_the_FoundationDB_Community_License_Agreement/key-value-store/${FDB_VERSION}/foundationdb-server_${FDB_VERSION}-1_amd64.deb" \
 && dpkg -i foundationdb-server_${FDB_VERSION}-1_amd64.deb \
 && rm foundationdb-server_${FDB_VERSION}-1_amd64.deb \
 && mv /etc/foundationdb/foundationdb.conf /usr/lib/foundationdb/foundationdb.conf.orig \
 && rm -rf /etc/foundationdb /var/lib/foundationdb/data

VOLUME ["/etc/foundationdb", "/fdb-data"]

EXPOSE 4500

ADD docker-start.sh /usr/lib/foundationdb/
ADD supervisord.conf /etc/

CMD ["/usr/local/bin/supervisord", "-c", "/etc/supervisord.conf"]
