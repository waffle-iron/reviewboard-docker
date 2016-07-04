#!/bin/bash

set -e

# TODO Support for postgress and sqlite

# Default to MySQL
: ${DATABASE:=mysql}

if [[ "$DATABASE" == "mysql" ]]; then
    # if we're linked to MySQL and thus have credentials already, let's use them
    # Default to root
    : ${REVIEWBOARD_DB_USER:=${MYSQL_ENV_MYSQL_USER:-root}}
    if [ "$REVIEWBOARD_DB_USER" = 'root' ]; then
        : ${REVIEWBOARD_DB_PASSWORD:=$MYSQL_ENV_MYSQL_ROOT_PASSWORD}
    fi
    : ${REVIEWBOARD_DB_PASSWORD:=$MYSQL_ENV_MYSQL_PASSWORD}
    # Default to "reviewboard"
    : ${REVIEWBOARD_DB_NAME:=${MYSQL_ENV_MYSQL_DATABASE:-reviewboard}}

elif [[ "$DATABASE" == "postgresql" ]]; then

    echo >&2 'ERROR: PostgreSQL support not implemented yet in Docker image.'
    exit 2

elif [[ "$DATABASE" == "sqlite3" ]]; then

    echo >&2 'ERROR: SQLite3 support not implemented yet in Docker image.'
    exit 2

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

mkdir -p /var/www/

if [[ ! -d /var/www/reviewboard ]]; then
# TODO Setup the Python loader with wsgi
# TODO Add memcache
    rb-site install --noinput \
        --domain-name="$DOMAIN" \
        --site-root=/ --static-url=static/ --media-url=media/ \
        --db-type=$DATABASE \
        --db-name="$REVIEWBOARD_DB_NAME" \
        --db-host="$REVIEWBOARD_DB_HOSTNAME" \
        --db-user="$REVIEWBOARD_DB_USER" \
        --db-pass="$REVIEWBOARD_DB_PASSWORD" \
        --web-server-type=apache --python-loader=modpython\
        --admin-user=admin --admin-password=admin --admin-email=admin@example.com \
        /var/www/reviewboard/
fi
