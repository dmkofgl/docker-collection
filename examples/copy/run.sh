docker build -t example-copy .

docker run --rm example-copy

docker build -t example-copy-invalid -f Dockerfile-invalid .