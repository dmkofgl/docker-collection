volumeName=hello-vol
docker volume create $volumeName
#If you specify a volume name already in use on the current driver, Docker assumes you want to reuse the existing volume and doesn't return an error.
docker volume create $volumeName

docker build -t testing .
docker run --rm -v $volumeName:/base testing
docker run --rm -it --name test-vol -v $volumeName:/world ubuntu ls -lR world/

docker volume inspect $volumeName

docker volume ls
docker volume create not-used

docker volume prune

docker volume create not-used-again

docker volume rm not-used-again
#Can't remove used volume
docker volume rm $volumeName
