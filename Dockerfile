# Pull base image.
FROM jlesage/baseimage-gui:debian-10

# Install puddletag
RUN apt update
RUN apt install -y software-properties-common python3 python3-mutagen python3-configobj python3-pyparsing python3-pyqt5 python3-pyqt5.qtsvg python3-unidecode git
# Generate and install favicons.
RUN \
    APP_ICON_URL=https://raw.githubusercontent.com/jlesage/docker-templates/master/jlesage/images/jdownloader-2-icon.png && \
    install_app_icon.sh "$APP_ICON_URL"

# Add Audible files.
RUN mkdir -p /puddletag
WORKDIR /puddletag

RUN git clone 'https://github.com/puddletag/puddletag'
RUN git clone 'https://github.com/seanap/Audible.com-Search-by-Album.git' ~/.puddletag/mp3tag_sources

COPY startapp.sh /startapp.sh

# Define mountable directories.
VOLUME ["/audiobooks"]
VOLUME ["/music"]
