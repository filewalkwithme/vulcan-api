#!/usr/bin/env bash

docker run --net=host --rm -v "$PWD":/flyway/sql flyway/flyway:"${FLYWAY_VERSION:-8}-alpine" \
    -user=vulcanito -password=vulcanito -url=jdbc:postgresql://localhost:5432/vulcanito -baselineOnMigrate=true clean

docker run --net=host --rm -v "$PWD":/flyway/sql flyway/flyway:"${FLYWAY_VERSION:-8}-alpine" \
    -user=vulcanito_test -password=vulcanito_test -url=jdbc:postgresql://localhost:5432/vulcanito_test -baselineOnMigrate=true clean

#docker exec vulcanito_db psql -c "DROP USER vulcanito_test;" -U postgres
