#!/usr/bin/env bash
PG_USER="${PG_USER:-postgres}"

docker exec vulcanito_db psql -c "DROP DATABASE IF EXISTS vulcanito_test;" -U $PG_USER
docker exec vulcanito_db psql -c "DROP USER IF EXISTS vulcanito_test;" -U $PG_USER
docker exec vulcanito_db psql -c "CREATE USER vulcanito_test WITH PASSWORD 'vulcanito_test';" -U $PG_USER
docker exec vulcanito_db psql -c "ALTER USER vulcanito_test WITH SUPERUSER;" -U $PG_USER
docker exec vulcanito_db psql -c "CREATE DATABASE vulcanito_test;" -U $PG_USER

docker run --net=host --rm -v "$PWD":/scripts flyway/flyway:"${FLYWAY_VERSION:-8}-alpine" \
    -user=vulcanito -password=vulcanito -url=jdbc:postgresql://localhost:5432/vulcanito \
    -locations=filesystem:/scripts/sql -baselineOnMigrate=true migrate

docker run --net=host --rm -v "$PWD":/scripts flyway/flyway:"${FLYWAY_VERSION:-8}-alpine" \
    -user=vulcanito_test -password=vulcanito_test -url=jdbc:postgresql://localhost:5432/vulcanito_test \
    -locations=filesystem:/scripts/sql,filesystem:/scripts/test-sql -baselineOnMigrate=true migrate
