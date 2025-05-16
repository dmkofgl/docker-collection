# docker inspect -f '{{.HostConfig.LogConfig.Type}}' drivers-logger-1
#docker run  --rm -it --log-driver local --log-opt max-size=10m --log-opt max-file=3 alpine ash
#docker run -it --log-opt max-size=10m --log-opt max-file=3 alpine ash