#!/bin/bash

set -e

# TODO Support for postgress and sqlite

if [[ "$DATABASE" == "mysql" ]]; then
    # if we're linked to MySQL and thus have credentials already, let's use them
    : ${REVIEWBOARD_DB_USER:=${MYSQL_ENV_MYSQL_USER:-root}}
    if [ "$REVIEWBOARD_DB_USER" = 'root' ]; then
        : ${REVIEWBOARD_DB_PASSWORD:=$MYSQL_ENV_MYSQL_ROOT_PASSWORD}
    fi
    : ${REVIEWBOARD_DB_PASSWORD:=$MYSQL_ENV_MYSQL_PASSWORD}
    : ${REVIEWBOARD_DB_NAME:=${MYSQL_ENV_MYSQL_DATABASE:-reviewboard}}
fi

if [ -z "$REVIEWBOARD_DB_PASSWORD" ]; then
    echo >&2 'error: missing required REVIEWBOARD_DB_PASSWORD environment variable'
    echo >&2 '  Did you forget to -e REVIEWBOARD_DB_PASSWORD=... ?'
    echo >&2
    echo >&2 '  (Also of interest might be REVIEWBOARD_DB_USER and REVIEWBOARD_DB_NAME.)'
    exit 1
fi

: "${REVIEWBOARD_DB_HOSTNAME:=dbserver}"
: "${DOMAIN:=localhost}"
