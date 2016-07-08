[![Build Status](https://travis-ci.org/ovidiub13/reviewboard-docker.svg?branch=master)](https://travis-ci.org/ovidiub13/reviewboard-docker)

ReviewBoard image for production use.

Check docker-compose.yml for detailed instructions.

Usage:

```bash
docker-compose -f docker-compose-mysql.yml up db
# wait for db setup to complete
docker-compose -f docker-compose-mysql.yml up reviewboard
```
