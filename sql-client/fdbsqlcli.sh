#!/bin/bash

args_file=$(mktemp)
echo -h $SQL_PORT_15432_TCP_ADDR $FDBSQLCLI_ARGS >$args_file
xargs -a $args_file fdbsqlcli
