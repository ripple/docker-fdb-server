FROM fdb-client

ENV FDB_SQL_VERSION 2.1.0

RUN apt-get update && apt-get install -y --no-install-recommends \
      default-jre-headless \
 && rm -rf /var/lib/apt/lists/*

RUN curl -SLO "https://foundationdb.com/downloads/I_accept_the_FoundationDB_Community_License_Agreement/sql-layer/${FDB_SQL_VERSION}/fdb-sql-layer-client-tools_${FDB_SQL_VERSION}-1_all.deb" \
 && dpkg -i fdb-sql-layer-client-tools_${FDB_SQL_VERSION}-1_all.deb \
 && rm fdb-sql-layer-client-tools_${FDB_SQL_VERSION}-1_all.deb

ADD fdbsqlcli.sh /

CMD /fdbsqlcli.sh
