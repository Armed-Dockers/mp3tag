# Pull base image.
FROM jlesage/baseimage-gui:debian-10

# Install puddletag
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
RUN chmod +x startapp.sh

# Define mountable directories.
VOLUME ["/audiobooks"]
VOLUME ["/music"]
