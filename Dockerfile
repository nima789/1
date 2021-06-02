FROM alpine:3.5

ADD install.sh /install.sh

RUN  chmod +x /install.sh

CMD /install.sh
