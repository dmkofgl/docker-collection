
#docker build -t example-copy-github -f https://github.com/dmkofgl/docker-collection.git#master:examples/remote-build-context/Dockerfile .
#docker run --rm  example-copy-github
touch test.txt

docker build -t example-copy-github -f Dockerfile https://github.com/dmkofgl/docker-collection.git#master:examples/remote-build-context

docker run --rm  example-copy-github