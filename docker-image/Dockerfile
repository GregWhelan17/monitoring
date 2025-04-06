FROM ubuntu:latest
ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtimezone && echo $TZ > /etc/timezone
# RUN --mount=type=secret,id=aptconf,target=/etc/apt/auth.conf \
RUN apt-get -y update && apt-get install -y apt-transport-https ca-certificates gnupg curl jq python3 python3-pip python3-venv vim sudo apt-get kubectl \
    && apt-get upgrade -y
RUN curl --fail -k -o /opt/hsbc.pem https://vagrant:vagrant@gbmt-nexus.prd.fx.gbm.cloud.uk.hsbc/repository/gbm-tools/certs/truststore-prod-2.0.12.pem
RUN  --mount=type=secret,id=pipconf,target=/root/.config/pip/pip.conf python3 -m venv .venv && /.venv/bin/pip install google-cloud-storage

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/entrypoint.sh"]