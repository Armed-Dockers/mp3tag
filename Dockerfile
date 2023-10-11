# Pull base image.
FROM jlesage/baseimage-gui:debian-11-v4

# Install puddletag
RUN apt update
RUN apt install -y software-properties-common git python3 python3-mutagen python3-configobj python3-pyparsing python3-pyqt5 python3-pyqt5.qtsvg python3-unidecode
# # Generate and install favicons.
# RUN \
#     APP_ICON_URL=https://raw.githubusercontent.com/jlesage/docker-templates/master/jlesage/images/jdownloader-2-icon.png && \
#     install_app_icon.sh "$APP_ICON_URL"

# Install puddletag
# RUN git clone 'https://github.com/puddletag/puddletag'
# WORKDIR puddletag

COPY startapp.sh /startapp.sh
RUN chmod +x /startapp.sh

# Create a new user
RUN useradd -ms /bin/bash puddle
RUN usermod -aG sudo puddle
USER puddle
WORKDIR /home/puddle
RUN git clone 'https://github.com/puddletag/puddletag' /home/puddle/puddletag
RUN git clone 'https://github.com/seanap/Audible.com-Search-by-Album.git' /home/puddle/.puddletag/mp3tag_sources
# RUN mkdir -p /root/.puddletag/mp3tag_sources && cp -r audible/* /root/.puddletag/mp3tag_sources
USER root
# Define mountable directories.
VOLUME ["/audiobooks"]
VOLUME ["/music"]
