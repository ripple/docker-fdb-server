FROM fdb-sql-client

RUN apt-get update && apt-get install -y --no-install-recommends \
      python \
      python-setuptools \
 && easy_install supervisor && mkdir -p /var/log/supervisor \
 && rm -rf /var/lib/apt/lists/*

RUN curl -SLO "https://foundationdb.com/downloads/I_accept_the_FoundationDB_Community_License_Agreement/sql-layer/${FDB_SQL_VERSION}/fdb-sql-layer_${FDB_SQL_VERSION}-1_all.deb" \
 && dpkg -i fdb-sql-layer_${FDB_SQL_VERSION}-1_all.deb \
 && rm fdb-sql-layer_${FDB_SQL_VERSION}-1_all.deb

RUN echo >>/etc/foundationdb/sql/server.properties \
 && echo 'fdbsql.postgres.host=0.0.0.0' >>/etc/foundationdb/sql/server.properties \
 && echo 'fdbsql.http.host=0.0.0.0' >>/etc/foundationdb/sql/server.properties \
 && mv /etc/foundationdb/sql /etc/fdb-sql

EXPOSE 15432 8091

ADD docker-sql-layer.sh /usr/lib/foundationdb/
ADD supervisord.conf /etc/

CMD ["/usr/local/bin/supervisord", "-c", "/etc/supervisord.conf"]
