FROM alpine:3.12

LABEL AUTHOR="none" \
      VERSION=0.1.4
      
ENV BASE=/jd \
    ## 项目分支
    JD_BASE_BRANCH=master \
    ## 项目地址
    JD_BASE_URL=git@jd_base_gitee:supermanito/jd_base.git \
    ## 活动脚本库私钥
    JD_KEY_BASE=/root/.ssh \
    JD_KEY_URL=https://raw.githubusercontent.com/nima789/JD-FreeFuck/part2/.ssh/ \
    JD_KEY1=config \
    JD_KEY2=jd_base \
    JD_KEY3=jd_scripts \
    JD_KEY4=known_hosts

RUN set -ex \
    && apk update \
    && apk upgrade \
    && apk add --no-cache tzdata git nodejs moreutils npm curl jq openssh-client wget perl net-tools\
    && rm -rf /var/cache/apk/* \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && mkdir -p /root/.ssh \
    ##下载私钥
    &&wget -P /root/.ssh $JD_KEY_URL$JD_KEY1 \
    &&wget -P /root/.ssh $JD_KEY_URL$JD_KEY2 \
    &&wget -P /root/.ssh $JD_KEY_URL$JD_KEY3 \
    &&wget -P /root/.ssh $JD_KEY_URL$JD_KEY4 \
    ## 安装私钥
    &&chmod 700 $JD_KEY_BASE \
    &&chmod 600 $JD_KEY_BASE/$JD_KEY1 \
    &&chmod 600 $JD_KEY_BASE/$JD_KEY2 \
    &&chmod 600 $JD_KEY_BASE/$JD_KEY3 \
    &&chmod 600 $JD_KEY_BASE/$JD_KEY4 \
    && cd /jd \
    && mkdir logs \
    && npm config set registry https://registry.npm.taobao.org \
    && npm install \
    ## 克隆项目
    git clone -b master git@jd_base_gitee:supermanito/jd_base.git /jd \
    && cp /jd/docker/docker-entrypoint.sh /usr/local/bin \
    && chmod +x /usr/local/bin/docker-entrypoint.sh

WORKDIR /jd

ENTRYPOINT ["docker-entrypoint.sh"]

CMD [ "crond" ]
    
    
    
    
