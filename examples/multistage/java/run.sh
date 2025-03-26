docker build -t multistage-java -f Dockerfile-java .

docker run --rm multistage-java

docker build -t multistage-java-build --target build -f Dockerfile-java .