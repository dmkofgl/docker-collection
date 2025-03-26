#!/bin/sh
tag=hello-entrypoint:0.0.1;
buildPath=.;

docker build -t $tag $buildPath;

docker run --rm  $tag;
echo "Container was stopped"

docker run --rm  $tag echo "It's third CMD!";
