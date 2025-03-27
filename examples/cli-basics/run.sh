containerName=nginx-testing;
docker run -d --name $containerName nginx

docker stop $containerName
docker rm $containerName

docker rmi nginx

docker ps

docker stats

