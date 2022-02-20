#!/bin/sh

count=5

if [ $# == 0 ]
then
    FLAG="run"
else
    FLAG=$1
fi

if [ $FLAG == "cleanup" ]
then
    echo "Docker container employee-app removing..."
    docker container stop employee-app
    echo "Docker container employee-db removing..."
    docker container stop employee-db
    echo "Volume employee-vol removing..."
    docker volume rm employee-vol
    echo "Network employee-net removing..."
    docker network rm employee-net
fi

if [ $FLAG == "run" ]
then
    echo "Network employee-net creating..."
    docker network create employee-net
    echo "Volume employee-vol creating..."
    docker volume create employee-vol
    echo "Docker container employee-db creating..."
    docker container run --rm -d --name employee-db -e MYSQL_ROOT_PASSWORD=root -e MYSQL_USER=employee -e MYSQL_PASSWORD=employee -e MYSQL_DATABASE=employeedb -p 3306:3306 -v employee-vol:/var/lib/mysql --network employee-net mysql:8.0.28
    echo "Docker container employee-app creating..."
    while [ $count -gt 0 ]
    do
        docker container run --rm --name employee-app -p 8080:8080 -e DB_HOST=employee-db --network employee-net kuriankevindev/employee-spring:1.0.0
        if [ $? == 143 ]
        then            
            break
        fi
        ((count=count-1))
    done
fi
