FROM python:3.12-alpine

WORKDIR /app

COPY . .

RUN apk add --no-cache \
        bash ca-certificates \
    && \
    apk add --no-cache --virtual=.build-deps \
        build-base \
        libffi-dev \
        openssl-dev \
        musl-dev \
    && pip install --upgrade --requirement /app/requirements.txt \
    && apk del --purge .build-deps \
    && chown -R root:root /app \
    && chmod -R 755 /app \
    && rm -rf \
        /root/.cache \
        /root/.cargo \
        /tmp/*

ENV PLEXAPI_CONFIG_PATH="/config/config.ini" \
    JBOPS_SCRIPT_PATH="fun/plexapi_haiku.py"

USER nobody:nogroup
VOLUME ["/config"]

ENTRYPOINT ["/bin/bash"]
CMD ["/docker-entrypoint.sh"]