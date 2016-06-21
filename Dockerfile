FROM pypi/eve

RUN groupadd user && useradd --create-home --home-dir /home/user -g user user

COPY settings.py /settings.py

RUN set -x \
    && apt-get update \
    && apt-get install -y --no-install-recommends curl ca-certificates \
    && apt-get install -y git \
    && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10 \
    && apt-get update \
    && apt-get install -y mongodb mongodb-server

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

CMD ["service", "mongod start"]
CMD ["python", "/tr-projects-rest/server.py"]
