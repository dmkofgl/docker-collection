FROM python:alpine
RUN apk add curl
HEALTHCHECK \
  --interval=5s \
  --timeout=3s \
#  --start-period=4s \
#  --retries=2 \
  CMD curl -f http://localhost:8081/ || exit 1
CMD echo "hello" && sh
