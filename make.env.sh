#!/bin/bash

ROOT=/home/pitagon/p5n.dev
DOMAIN=p5n.dev
SERVER_NAME=${DOMAIN}\ www.${DOMAIN}
HTTP_PORT=80
HTTPS_PORT=443
SSL_CERTIFICATE=/etc/letsencrypt/live/${DOMAIN}/fullchain.pem
SSL_CERTIFICATE_KEY=/etc/letsencrypt/live/${DOMAIN}/privkey.pem
PROXY_PASS=http://127.0.0.1:8080
CLIENT_MAX_BODY_SIZE=10m
