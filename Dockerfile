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
  nodejs-current
  
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
# cap V8 heap for the yt-dlp EJS challenge solver so it cannot balloon the container
ENV NODE_OPTIONS="--max-old-space-size=256"

ENTRYPOINT ["/bin/sh", "docker-entrypoint.sh", "--no-check"]
