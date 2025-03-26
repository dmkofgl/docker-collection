
echo "Use legacy builder";

DOCKER_BUILDKIT=0 docker build --no-cache -f Dockerfile-ubuntu --target stage2 . | grep  RUN

echo "Use BuildKit";

DOCKER_BUILDKIT=1 docker build --no-cache -f Dockerfile-ubuntu --target stage2 .