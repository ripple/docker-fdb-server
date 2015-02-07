#!/usr/bin/env sh

DIR=`dirname "$0"`

docker build -t fdb-client     ${DIR}/fdb-client/ 
docker build -t fdb-server     ${DIR}/fdb-server/
docker build -t fdb-sql-client ${DIR}/fdb-sql-client/
docker build -t fdb-sql-server ${DIR}/fdb-sql-server/
