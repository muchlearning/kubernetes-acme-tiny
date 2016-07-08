FROM alpine:edge
# edge is needed for thttpd
MAINTAINER Hubert Chathi <hubert@muchlearning.org>

EXPOSE 80
ENV K8SBASE="http://127.0.0.1:8000"

RUN apk add --update --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ thttpd python py-openssl py-pip py-six py-cryptography py-enum34 py-cffi openssl ca-certificates \
    && rm -rf /var/cache/apk/* \
    && mkdir -p /var/lib/acme-tiny/challenge/.well-known/acme-challenge \
    && pip install requests

WORKDIR /opt/acme-tiny-utils

COPY acme-tiny /opt/acme-tiny
COPY cert-chain-resolver-py /opt/cert-chain-resolver-py
COPY renew create_account_key create_domain_key put-certificate.py /opt/acme-tiny-utils/

CMD ["/usr/sbin/thttpd", "-nov", "-D", "-d", "/var/lib/acme-tiny/challenge", "-l", "/dev/stdout"]
