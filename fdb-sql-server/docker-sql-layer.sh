#!/bin/bash

if [ ! -d /etc/foundationdb/sql ]; then
    ln -s /etc/fdb-sql /etc/foundationdb/sql
fi

if [ -f /usr/lib/foundationdb/docker-sql-layer.hook.sh ]; then
    . /usr/lib/foundationdb/docker-sql-layer.hook.sh
fi

PIDFILE=/var/run/fdb-sql-layer.pid
rm -f $PIDFILE && touch $PIDFILE && chown foundationdb $PIDFILE
su -s /bin/bash -c "/usr/sbin/fdbsqllayer -H /usr/share/foundationdb/sql -c /etc/foundationdb/sql -p $PIDFILE -f >/var/log/foundationdb/sql/stdout.log" foundationdb
