#!/bin/sh

if [ $# == 0 ]
then
    FLAG="build"
else
    FLAG=$1
fi

if [ $FLAG == "cleanup" ]
then
    echo "Docker container employee-app removing..."
    docker container stop employee-app
    echo "Docker container employee-db removing..."
    docker container stop employee-db
    echo "Network employee-net removing..."
    docker network rm employee-net
    exit
fi

if [ $FLAG == "local" ]
then
    echo "Network employee-net creating..."
    docker network create employee-net
    echo "Docker container employee-db creating..."
    docker container run --rm -d --name employee-db -e MYSQL_ROOT_PASSWORD=root -e MYSQL_USER=employee -e MYSQL_PASSWORD=employee -e MYSQL_DATABASE=employeedb -p 3306:3306 --network employee-net mysql:8.0.28
    sleep 15
    echo "Docker container employee-app creating..."
    docker container run --rm -d --name employee-app -p 8080:8080 -e DB_HOST=employee-db --network employee-net kuriankevindev/employee-spring:1.0.0
else
    docker container run -p 8080:8080 kuriankevindev/employee-spring:1.0.0
fi
