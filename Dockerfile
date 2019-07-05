FROM debian:buster

RUN apt-get update && apt-get -y install \
    curl \
    jq \
  && rm -rf /var/lib/apt/lists/*

COPY prometheus-operator-sd.sh /

RUN mkdir /output && chown 1001.root /output && chmod g=u /output

VOLUME /output

USER 1001

ENTRYPOINT /prometheus-operator-sd.sh
