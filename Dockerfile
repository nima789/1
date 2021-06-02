FROM alpine:3.12

LABEL AUTHOR="none" \
      VERSION=0.1.4
    
RUN set -ex \
    && apk update \
    && apk upgrade \
    && apk add --no-cache tzdata git nodejs moreutils npm curl jq openssh-client wget perl net-tools\
    && rm -rf /var/cache/apk/* \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && mkdir -p /jd \
    && cd /jd \
    && wget https://raw.githubusercontent.com/nima789/1/main/install.sh \
    && cp /jd/install.sh /usr/local/bin \
    && chmod +x /usr/local/bin/install.sh
    
WORKDIR /jd

ENTRYPOINT ["install.sh"]

CMD [ "crond" ]
