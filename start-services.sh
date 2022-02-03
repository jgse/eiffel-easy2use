#!/usr/bin/env bash

./easy2use start Eiffel -t Docker --services rabbitmq,mongodb,remrem_generate,remrem_publish,er

# enable mqtt plugin
docker exec eiffel_rabbitmq_1 rabbitmq-plugins enable rabbitmq_web_mqtt
docker exec eiffel_rabbitmq_1 rabbitmqctl add_user jgsedemo jgsedemo
docker exec eiffel_rabbitmq_1 rabbitmqctl set_permissions -p / jgsedemo ".*" ".*" ".*"
docker exec eiffel_rabbitmq_1 rabbitmqctl set_user_tags jgsedemo management

# check 'eiffel' database 
docker exec eiffel_mongodb_1 mongo eiffel --eval "db.getCollectionNames()"
docker exec eiffel_mongodb_1 mongo eiffel --eval "db.events.count()"
# docker exec eiffel_mongodb_1 mongoexport --jsonFormat=canonical --db=eiffel --collection=events | tee export-events.json
# reset the database
docker exec eiffel_mongodb_1 mongo eiffel --eval "db.dropDatabase()"
docker exec eiffel_mongodb_1 mongo eiffel --eval "db.events.count()"
docker exec -i eiffel_mongodb_1 mongoimport --db=eiffel --collection=events < export-events.json
docker exec eiffel_mongodb_1 mongo eiffel --eval "db.events.count()"
