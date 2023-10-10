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

# Define software download URLs.
ARG MP3TAG_URL=https://index.monkdex.workers.dev/0:/mp3tagv322b-x64-setup.exe

# Pull base image.
FROM jlesage/baseimage-gui:debian-10

ARG DOCKER_IMAGE_VERSION

# Define working directory.
RUN mkdir /mp3tag
WORKDIR /mp3tag

# Install wine
RUN apt update
RUN apt install -y software-properties-common mono-complete wget unzip
RUN dpkg --add-architecture i386
RUN wget -nc https://dl.winehq.org/wine-builds/winehq.key
RUN apt-key add winehq.key
RUN add-apt-repository 'deb https://dl.winehq.org/wine-builds/debian/ buster main'
RUN apt update
RUN apt -y install --install-recommends winehq-stable

# Generate and install favicons.
RUN \
    APP_ICON_URL=https://raw.githubusercontent.com/jlesage/docker-templates/master/jlesage/images/jdownloader-2-icon.png && \
    install_app_icon.sh "$APP_ICON_URL"

# Add files.
COPY . /mp3tag
RUN curl -# -L -o mp3tag-setup.exe ${JDOWNLOADER_URL}

COPY startapp.sh /startapp.sh

# Set internal environment variables.
RUN \
    set-cont-env APP_NAME "Mp3tag" && \
    set-cont-env DOCKER_IMAGE_VERSION "$DOCKER_IMAGE_VERSION" && \
    true

# Define mountable directories.
VOLUME ["/audiobooks"]
VOLUME ["/music"]

# Metadata.
LABEL \
      org.label-schema.name="mp3tag" \
      org.label-schema.description="Docker container for Mp3tag" \
      org.label-schema.version="${DOCKER_IMAGE_VERSION:-unknown}" \
      org.label-schema.vcs-url="https://github.com/Armed-Dockers/mp3tag" \
      org.label-schema.schema-version="1.0"
