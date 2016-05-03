FROM pypi/eve

RUN groupadd user && useradd --create-home --home-dir /home/user -g user user

RUN set -x \
    && apt-get update \
    && apt-get install -y --no-install-recommends curl ca-certificates \
    && apt-get install -y git

COPY settings.py /settings.py

RUN buildDeps=' \
    gcc \
    make \
    python \
    ' \
  && set -x \
  && apt-get update && apt-get install -y $buildDeps --no-install-recommends && rm -rf /var/lib/apt/lists/* \
  && pip install --upgrade pip \
  && git clone https://github.com/twreporter/tr-projects-rest.git \
  && cp /settings.py ./ \
  && pip install flask \
  && pip install Eve \
  && cd tr-projects-rest \
  && mv settings.sample.py settings.py

EXPOSE 8080
RUN ["python", "/tr-projects-rest/server.py"]
