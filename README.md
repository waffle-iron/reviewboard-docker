[![Build Status](https://travis-ci.org/ovidiub13/reviewboard-docker.svg?branch=master)](https://travis-ci.org/ovidiub13/reviewboard-docker)

# ReviewBoard image for production use

This ReviewBoard image uses Apache2 with mod_wsgi to serve ReviewBoard. It currently supports just MySQL as a database backend. PostgreSQL and SQLite3 soon to be added.

This image was built acording to the [ReviewBoard install documentation](https://www.reviewboard.org/docs/manual/2.5/admin/installation/linux/).

# How to use this image:

ReviewBoard requires a database in order to run. You can either use a container or another host. Make sure the database is accesible before starting the ReviewBoard container.

## Database in a container

### MySQL example:

    docker run -d --name=rb_db -e MYSQL_ROOT_PASSWORD='supersecretpassword' -e MYSQL_DATABASE='reviewboard' -v mysql-utf8.cnf:/etc/mysql/conf.d/mysql-utf8.cnf:ro -v /var/lib/mysql mysql:5.7.13

This uses the `mysql-utf8.cnf` file to ensure that the DB runs in UTF-8.

### PostgreSQL example:

    # [TBD]

### SQLite3 example:

    # [TBD]

## Database on another server

When starting the ReviewBoard container, provide the following variables with their respective values:

* `REVIEWBOARD_DB_HOSTNAME`
* `REVIEWBOARD_DB_USER`
* `REVIEWBOARD_DB_PASSWORD`
* `REVIEWBOARD_DB_NAME`

## Starting a container

Use the `DATABASE` variable to specify the database backend to be used.
If you are using a database in a container, link to that container.

    docker run -d --link rb_db:dbserver -p 80:80 -e DATABASE=mysql ovidiub13/reviewboard

# Docker-compose

A `docker-compose` YAML file is available (currently just for MySQL) for easing the use of this image.
The image currently does not wait for the DB to be available, so the database container and the ReviewBoard container need to be started separately.

    docker-compose -f docker-compose-mysql.yml up -d db
    # wait for db setup to complete
    docker-compose -f docker-compose-mysql.yml up -d reviewboard

Don't forget to change the database password.

# TODO

- [ ] Support for Memcache
- [ ] Volumes for media and other data
- [ ] Support for PostgreSQL
- [ ] Support for SQLite3
