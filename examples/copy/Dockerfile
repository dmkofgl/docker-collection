FROM busybox

WORKDIR ~/example

COPY folder .

# unarchive files
ADD folder/d.tar ./archive

ADD https://github.com/dmkofgl/docker-collection/blob/master/examples/copy/folder/c.txt ./github/

ENTRYPOINT ["ls", "-R"]