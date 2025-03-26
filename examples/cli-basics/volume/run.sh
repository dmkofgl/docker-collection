
#docker volume create hello-vol
##If you specify a volume name already in use on the current driver, Docker assumes you want to reuse the existing volume and doesn't return an error.
#docker volume create hello-vol

docker build -t testing .
#docker run --rm -v hello-vol:/base testing
#docker run --rm -it --name test-vol -v hello-vol:/world ubuntu ls -l world/


