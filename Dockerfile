FROM alpine:edge # edge is needed for thttpd
MAINTAINER Hubert Chathi <hubert@muchlearning.org>

EXPOSE 80

RUN apk add --update thttpd python py-openssl openssl \
    && rm -rf /var/cache/apk/*

COPY thttpd.conf /etc/thttpd.conf
COPY acme-tiny cert-chain-resolver-py /opt/

CMD ["/usr/sbin/thttpd", "-nov", "-D"]
