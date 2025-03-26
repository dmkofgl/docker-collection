docker build -t example-copy .

docker run --rm example-copy

docker build -t example-copy-github  https://github.com/dmkofgl/docker-collection/
docker run --rm example-copy-github