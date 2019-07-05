FROM debian:buster

RUN apt-get update && apt-get -y install \
    curl \
    jq \
  && rm -rf /var/lib/apt/lists/*

COPY prometheus-operator-sd.sh /

USER 1001

ENTRYPOINT /prometheus-operator-sd.sh
