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
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
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
    &&chmod 600 $JD_KEY_BASE/$JD_KEY4 
    ## 克隆项目
RUN git clone -b $JD_BASE_BRANCH $JD_BASE_URL $BASE \
    ## 创建目录
    &&mkdir $BASE/config \
    &&mkdir $BASE/log \
    ## 根据安装目录配置定时任务
    &&sed -i "s#BASE#$BASE#g" $BASE/sample/computer.list.sample \
    ## 创建项目配置文件与定时任务配置文件
    &&cp $BASE/sample/config.sh.sample $BASE/config/config.sh \
    &&cp $BASE/sample/computer.list.sample $BASE/config/crontab.list \
    ## 切换 npm 官方源为淘宝源
    &&npm config set registry http://registry.npm.taobao.org \ 
    ## 安装控制面板功能
    &&cp $BASE/sample/auth.json $BASE/config/auth.json \
    &&echo -e "{\"user\":\"xz123\",\"password\":\"20001201\"}" > $BASE/config/auth.json \
    &&cd $BASE/panel \
    &&npm install || npm install --registry=https://registry.npm.taobao.org \
    &&npm install -g pm2 \
    &&pm2 start ecosystem.config.js
    ## 拉取活动脚本
    WORKDIR /jd
    ENTRYPOINT ["git_pull.sh"]

    
    
    
    
