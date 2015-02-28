# FoundationDB Server Docker Image

[![Docker Repository on Quay.io](https://quay.io/repository/ripple/fdb-server/status "Docker Repository on Quay.io")](https://quay.io/repository/ripple/fdb-server)

Based on Mike McMahon's [excellent scripts](https://bitbucket.org/mmcm/sql-layer-docker). Modified to follow official Docker images' practices more closely by [Peter Petrov](https://github.com/pesho/docker-fdb). This repository is maintained by the folks at [Ripple Labs](https://ripplelabs.com).

# Usage

This image represents a basic FoundationDB server.

``` sh
# Run a FoundationDB Server
docker run -d --name fdb quay.io/ripple/fdb-server

# Connect to it from another container and print the cluster status
docker run --rm --volumes-from fdb quay.io/ripple/fdb-client fdbcli --exec "status details"
```

## A multi-container cluster

A second container that uses the same cluster file will join that cluster rather than making a new one.

``` sh
docker run -d --volumes-from fdb --name fdb2 quay.io/ripple/fdb-server
docker run --rm --volumes-from fdb quay.io/ripple/fdb-client fdbcli --exec "status details"
```

```
...
Cluster:
  FoundationDB processes - 2
  Machines               - 2
...
Process performance details:
  172.17.0.85:4500 ...
  172.17.0.87:4500 ...
...
```

# Related Images

| Image | [GitHub](https://github.com) | [Quay.io](https://quay.io) |
| ----- | ------ | ------- |
| FoundationDB Server | [ripple/docker-fdb-server](https://github.com/ripple/docker-fdb-server) | [![Docker Repository on Quay.io](https://quay.io/repository/ripple/fdb-server/status "Docker Repository on Quay.io")](https://quay.io/repository/ripple/fdb-server) |
| FoundationDB Client | [ripple/docker-fdb-client](https://github.com/ripple/docker-fdb-client) | [![Docker Repository on Quay.io](https://quay.io/repository/ripple/fdb-client/status "Docker Repository on Quay.io")](https://quay.io/repository/ripple/fdb-client) |
