FROM debian:buster

RUN apt-get update && apt-get -y install \
    jq \
  && rm -rf /var/lib/apt/lists/*

COPY prometheus-operator-sd.sh /

ENTRYPOINT /prometheus-operator-sd.sh
