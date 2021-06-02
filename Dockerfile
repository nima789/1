FROM alpine:3.5

ADD install.sh /install.sh

RUN  wget https://raw.githubusercontent.com/nima789/1/main/install.sh && chmod +x /install.sh

CMD /install.sh
