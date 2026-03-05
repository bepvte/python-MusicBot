FROM python:3.14-alpine

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
  git \
  curl \
  deno
  
COPY requirements.txt .

# Install pip dependencies
RUN pip3 install --no-cache-dir -r requirements.txt

# Clean up build dependencies
RUN apk del .build-deps

COPY . ./
COPY ./config sample_config

# Create volumes for audio cache, config, data and logs
# VOLUME ["/musicbot/audio_cache", "/musicbot/config", "/musicbot/data", "/musicbot/logs"]

ENV APP_ENV=docker
ENV PATH="$PATH:/root/.deno/bin/"

ENTRYPOINT ["/bin/sh", "docker-entrypoint.sh", "--no-check"]
