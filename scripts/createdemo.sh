#!/bin/sh
cd microservice-demo
mvn package
cd ..
cd docker
docker-compose build
