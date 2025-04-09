FROM ubuntu:latest
ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtimezone && echo $TZ > /etc/timezone
RUN apt-get -y update && apt-get install -y apt-transport-https ca-certificates gnupg curl jq python3 python3-pip python3-venv vim sudo apt-get kubectl \
    && apt-get upgrade -y
RUN  python3 -m venv .venv && /.venv/bin/pip install google-cloud-storage

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/entrypoint.sh"]