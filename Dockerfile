FROM pypi/eve

RUN groupadd user && useradd --create-home --home-dir /home/user -g user user
COPY dump /dump

RUN set -x \
    && apt-get update \
    && apt-get install -y --no-install-recommends curl ca-certificates \
    && apt-get install -y git \
    && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927 \
    && echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.2 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.2.list \
    && apt-get update \
    && touch /etc/init.d/mongod \
    && chmod 755 /etc/init.d/mongod \
    && apt-get install -y mongodb-org-server=3.2.7 \
    && apt-get install -y mongodb-org=3.2.7

RUN buildDeps=' \
    gcc \
    make \
    python \
    ' \
    && set -x \
    && apt-get update && apt-get install -y $buildDeps --no-install-recommends && rm -rf /var/lib/apt/lists/* \
    && pip install --upgrade pip \
    && git clone https://github.com/twreporter/tr-projects-rest.git \
    && cd /tr-projects-rest/ \
    && git checkout keystone \
    && pip install flask \
    && pip install Eve \
    && cp /tr-projects-rest/settings.sample.py /tr-projects-rest/settings.py

EXPOSE 8080
EXPOSE 27017

CMD ["mongod","--port 27017"]
CMD ["python", "/tr-projects-rest/server.py"]
