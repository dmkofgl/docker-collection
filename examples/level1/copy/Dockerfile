FROM busybox

WORKDIR ~/example

COPY folder .

# unarchive files
ADD folder/d.tar ./archive

ADD https://raw.githubusercontent.com/dmkofgl/docker-collection/master/examples/copy/folder/c.txt ./github/

ENTRYPOINT ["cat", "github/c.txt"]

ENTRYPOINT ["ls", "-R"]
