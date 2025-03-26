#!/bin/sh
tag=example-arg;
buildPath=.;
containerName=hello-example-args

docker build -f Dockerfile-arg -t $tag $buildPath;
docker run  --rm --name $containerName   $tag