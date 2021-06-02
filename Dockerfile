FROM alpine:3.5

ADD install.sh /install.sh

RUN set -ex \
    && apk update \
    && apk upgrade \
    && apk add --no-cache tzdata git nodejs moreutils npm curl jq openssh-client wget perl net-tools\
    && rm -rf /var/cache/apk/* \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && wget https://raw.githubusercontent.com/nima789/1/main/install.sh \
    && chmod +x /install.sh

CMD /install.sh
