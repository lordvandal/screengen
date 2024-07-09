########################################################
# Dockerfile: Alpine Linux & screengen by Oleg Kochkin #
########################################################

FROM alpine:latest AS build

RUN apk upgrade --no-cache && \
    apk add --no-cache git g++ make qt5-qtbase qt5-qtbase-dev ffmpeg ffmpeg-dev && \
    git clone https://github.com/OlegKochkin/screengen && \
    cd screengen && \
    qmake-qt5 && \
    make && \
    make install_target

FROM alpine:latest

COPY --from=build /usr/bin/screengen /usr/bin/screengen

RUN apk upgrade --no-cache && \
    apk add --no-cache tzdata bash bash-completion qt5-qtbase ffmpeg && \
    cp /usr/share/zoneinfo/Europe/Bucharest /etc/localtime && \
    echo "Europe/Bucharest" > /etc/timezone && \
    apk del tzdata &&\
    chmod +x /usr//bin/screengen

CMD ["run.sh"]
