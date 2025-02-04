FROM python:3.11-alpine

# Add project source
WORKDIR /musicbot
# Install build dependencies
RUN apk update && apk add --no-cache --virtual .build-deps \
  build-base \
  libffi-dev \
  libsodium-dev

# Install dependencies
RUN apk update && apk add --no-cache \
  ca-certificates \
  ffmpeg \
  opus-dev \
  libffi \
  libsodium \
  gcc \
  git

COPY requirements.txt .

# Install pip dependencies
RUN pip3 install --no-cache-dir --pre -r requirements.txt

# Clean up build dependencies
RUN apk del .build-deps

COPY . ./
COPY ./config sample_config

# Create volumes for audio cache, config, data and logs
# VOLUME ["/musicbot/audio_cache", "/musicbot/config", "/musicbot/data", "/musicbot/logs"]

ENV APP_ENV=docker

CMD ["/bin/sh", "docker-entrypoint.sh"]
