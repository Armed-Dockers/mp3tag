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

# Pull base image.
FROM jlesage/baseimage-gui:debian-10

# Install wine
RUN apt update
RUN apt install -y software-properties-common python-pyqt5 python-pyparsing python-mutagen git
RUN apt update
RUN apt install -y puddletag
# Generate and install favicons.
RUN \
    APP_ICON_URL=https://raw.githubusercontent.com/jlesage/docker-templates/master/jlesage/images/jdownloader-2-icon.png && \
    install_app_icon.sh "$APP_ICON_URL"

# Add Audible files.
RUN git clone https://github.com/seanap/Audible.com-Search-by-Album.git ~/.puddletag/mp3tag_sources

COPY startapp.sh /startapp.sh

# Define mountable directories.
VOLUME ["/audiobooks"]
VOLUME ["/music"]
