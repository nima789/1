FROM alpine:3.12

LABEL AUTHOR="none" \
      VERSION=0.1.4

ENV BASE=/jd \
    ## 项目分支
    JD_BASE_BRANCH=master \
    ## 项目地址
    JD_BASE_URL=git@jd_base_gitee:supermanito/jd_base.git \
    ## 活动脚本库私钥
    JD_KEY_BASE=/.ssh \
    JD_KEY_URL=https://raw.githubusercontent.com/nima789/1/.ssh/ \
    JD_KEY1=config \
    JD_KEY2=jd_base \
    JD_KEY3=jd_scripts \
    JD_KEY4=known_hosts

RUN set -ex \
    &&firewall-cmd --zone=public --add-port=5678/tcp --permanent >/dev/null 2>&1 \
    &&systemctl reload firewalld >/dev/null 2>&1\
    && apk update \
    && apk upgrade \
    && apk add --no-cache tzdata git nodejs moreutils npm curl jq openssh-client wget perl net-tools\
    && rm -rf /var/cache/apk/* \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    ##下载私钥
    &&wget --no-check-certificate $JD_KEY_BASE $JD_KEY_URL$JD_KEY1 \
    &&wget --no-check-certificate $JD_KEY_BASE $JD_KEY_URL$JD_KEY2 \
    &&wget --no-check-certificate $JD_KEY_BASE $JD_KEY_URL$JD_KEY3 \
    &&wget --no-check-certificate $JD_KEY_BASE $JD_KEY_URL$JD_KEY4 \
    ## 安装私钥
    &&chmod 700 $JD_KEY_BASE \
    &&chmod 600 $JD_KEY_BASE/$JD_KEY1 \
    &&chmod 600 $JD_KEY_BASE/$JD_KEY2 \
    &&chmod 600 $JD_KEY_BASE/$JD_KEY3 \
    &&chmod 600 $JD_KEY_BASE/$JD_KEY4 \ 
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
    &&pm2 start ecosystem.config.js \
    ## 拉取活动脚本
    &&bash $BASE/git_pull.sh \
    &&bash $BASE/git_pull.sh >/dev/null 2>&1 \
    ## 创建软链接
    &&ln -sf $BASE/jd.sh /usr/local/bin/jd \
    &&ln -sf $BASE/git_pull.sh /usr/local/bin/git_pull \
    &&ln -sf $BASE/rm_log.sh /usr/local/bin/rm_log \
    &&ln -sf $BASE/export_sharecodes.sh /usr/local/bin/export_sharecodes \
    &&ln -sf $BASE/run_all.sh /usr/local/bin/run_all \
    ## 定义全局变量
    &&echo "export JD_DIR=$BASE" >>/etc/profile \
    &&source /etc/profile
    
WORKDIR $BASE

CMD [ "crond" ]
    
    
    
    
    