FROM python:3-slim

RUN apt -y update && DEBIAN_FRONTEND=noninteractive apt-get -qq install curl \
    && mkdir /www && echo 'Hello World!!!' > /www/index.html

EXPOSE 9000
CMD ["python3", "-m", "http.server", "-d", "/www", "9000"]