FROM ubuntu:22.04

ARG name=script

# install app dependencies
RUN apt-get update && apt-get install -y python3 python3-pip

RUN pip install flask==3.0.*

WORKDIR /app
COPY $name.py .
ADD Readme.md .


ENV FLASK_APP=$name

EXPOSE 8000

CMD ["flask", "run","--host", "0.0.0.0", "--port", "8000"]