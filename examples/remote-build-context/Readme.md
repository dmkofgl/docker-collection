[run-remote-build.sh](run-remote-build.sh) generate file [test.txt](test.txt),
but container don't copy it, so it use build context of repository. 
You can also remove local Dockerfile and it'll still create a container 
