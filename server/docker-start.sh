#/bin/bash

HOSTADDR=$(grep $HOSTNAME /etc/hosts | cut -f1)
COORDADDR=$HOSTADDR:4500
CONFFILE=/etc/foundationdb/$HOSTNAME.conf

if [ ! -f $CONFFILE ]; then
    cp /usr/lib/foundationdb/foundationdb.conf.orig $CONFFILE

    if [ -n "$FDB_PROCESS_COUNT" -o -n "$FDB_PUBLIC_ADDR" ]; then
        if [ -z "$FDB_PROCESS_COUNT" ]; then FDB_PROCESS_COUNT=1; fi
        if [ -n "$FDB_PUBLIC_ADDR" ]; then FDB_PUBLIC_PORTS=(${FDB_PUBLIC_PORT//,/ }); fi

        sed -i -e 's/\[fdbserver\.4500\]//' $CONFFILE

        N=0
        while [ $N -lt $FDB_PROCESS_COUNT ]; do
            echo >>$CONFFILE
            echo "[fdbserver.$((4500+N))"] >>$CONFFILE
            if [ -n "$FDB_PUBLIC_ADDR" ]; then
                if [ $N -eq 0 ]; then COORDADDR=$FDB_PUBLIC_ADDR:${FDB_PUBLIC_PORTS[$N]}; fi
                echo "listen_address = $HOSTADDR:$((4500+N))" >>$CONFFILE
                echo "public_address = $FDB_PUBLIC_ADDR:${FDB_PUBLIC_PORTS[$N]}"  >>$CONFFILE
            fi
            N=$((N+1))
        done
    fi
fi

if [ ! -f /etc/foundationdb/fdb.cluster ]; then
    echo "docker:$HOSTNAME@$COORDADDR" >/etc/foundationdb/fdb.cluster
    chown -R foundationdb:foundationdb /etc/foundationdb
    chmod 0644 /etc/foundationdb/fdb.cluster
    NEWDB=yes
fi

if [ ! -d /var/lib/foundationdb/data ]; then
    chmod go+rx /fdb-data
    DATADIR=/fdb-data/$HOSTNAME
    mkdir $DATADIR
    chown foundationdb:foundationdb $DATADIR
    ln -s $DATADIR /var/lib/foundationdb/data
fi

set -m
/usr/lib/foundationdb/fdbmonitor --conffile $CONFFILE --lockfile /var/run/fdbmonitor.pid &

CMD=status
if [ "$NEWDB" = "yes" ]; then
  CMD="configure new single memory; status"
fi

fdbcli --exec "$CMD" --timeout 60

fg
