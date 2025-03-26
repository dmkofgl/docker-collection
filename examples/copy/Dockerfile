FROM busybox

WORKDIR ~/example

COPY folder .

# unarchive files
ADD folder/d.tar ./archive

ENTRYPOINT ["ls", "-R"]