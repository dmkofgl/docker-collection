#!/bin/sh
tag=hello-python:0.0.1;
buildPath=.;
portContainer=8000;
portHost=8001
containerName=hello-world-python

docker build -t $tag $buildPath;
#docker build --no-cache -t $tag $buildPath;

containerId=$(docker run --name $containerName -d -p $portHost:$portContainer $tag)
#
open http://localhost:$portHost

docker stop $containerId
docker rm $containerId