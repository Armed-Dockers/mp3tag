#
# jdownloader-2 Dockerfile
#
# https://github.com/jlesage/docker-jdownloader-2
#
# NOTES:
#   - We are using JRE version 8 because recent versions are much bigger.
#   - JRE for ARM 32-bits on Alpine is very hard to get:
#     - The version in Alpine repo is very, very slow.
#     - The glibc version doesn't work well on Alpine with a compatibility
#       layer (gcompat or libc6-compat).  The `__xstat` symbol is missing and
#       implementing a wrapper is not straight-forward because the `struct stat`
#       is not constant across architectures (32/64 bits) and glibc/musl.
#

# Docker image version is provided via build arg.
ARG DOCKER_IMAGE_VERSION=

# Pull base image.
FROM jlesage/baseimage-gui:alpine-3.16-v4.4.2

ARG DOCKER_IMAGE_VERSION

# Define working directory.
RUN mkdir /mp3tag
WORKDIR /mp3tag

# Install dependencies.
RUN \
    add-pkg \
        unzip \
        java-common \
        openjdk8-jre \
        # Needed by the init script.
        jq \
        # We need a font.
        ttf-dejavu \
        # For ffmpeg and ffprobe tools.
        ffmpeg \
        # For rtmpdump tool.
        rtmpdump \
        # Need for the sponge tool.
        moreutils

# Generate and install favicons.
RUN \
    APP_ICON_URL=https://raw.githubusercontent.com/jlesage/docker-templates/master/jlesage/images/jdownloader-2-icon.png && \
    install_app_icon.sh "$APP_ICON_URL"

# Add files.
COPY . /mp3tag
RUN unzip mp3tag.zip && \
    rm mp3tag.zip

# Set internal environment variables.
RUN \
    set-cont-env APP_NAME "Mp3Tag" && \
    set-cont-env DOCKER_IMAGE_VERSION "$DOCKER_IMAGE_VERSION" && \
    true

# Define mountable directories.
VOLUME ["/audiobooks"]

# Metadata.
LABEL \
      org.label-schema.name="mp3tag" \
      org.label-schema.description="Docker container for Mp3Tag" \
      org.label-schema.version="${DOCKER_IMAGE_VERSION:-unknown}" \
      org.label-schema.vcs-url="https://github.com/Armed-Dockers/mp3tag" \
      org.label-schema.schema-version="1.0"
