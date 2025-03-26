name=cli-basics
tag=latest
registryHost=docker.io;
registryUser=your_docker_hub_username;

docker image build -t $name:$tag .

docker image history $name

docker image inspect $name

docker image ls | grep $name

docker image prune

docker image tag $name $registryUser/$name

docker image push $registryHost/$registryUser/$name

docker image rm $name:$tag

docker image rm $registryUser/$name
docker image pull ubuntu
docker image save --output ubuntu.tar ubuntu

docker image rm ubuntu

cat ubuntu.tar | docker image import - ubuntu-custom:import-tag
docker image load -i ubuntu.tar

echo import
docker image history ubuntu-custom:import-tag
echo load
docker image history ubuntu




