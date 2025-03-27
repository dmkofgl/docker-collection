networkName=my-net
docker network create -d bridge $networkName
docker network ls
docker run --network=$networkName -p 80 -dit --name=container2 busybox
docker run  --network=$networkName -dit  --name=container1 busybox

docker network inspect $networkName

docker stop container2
docker stop container1
docker rm container2
docker rm container1


docker run   -dit  --name=container3 busybox

docker network connect $networkName container3

docker run --network container:container3 --network clearing_default -dit  --name=container4  -p 8080:80 busybox
# container4 share same settings as container3 , don't connect directly to this network
docker network inspect $networkName
docker network inspect clearing_default

docker stop container3
docker stop container4
docker rm container3
docker rm container4
