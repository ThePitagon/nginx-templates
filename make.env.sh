#!/bin/bash

SERVER_NAME=pitagon.io
HTTP_PORT=80
HTTPS_PORT=443
SSL_CERTIFICATE=/etc/letsencrypt/live/${SERVER_NAME}/fullchain.pem
SSL_CERTIFICATE_KEY=/etc/letsencrypt/live/${SERVER_NAME}/privkey.pem
PROXY_PASS=http://127.0.0.1:8080
CLIENT_MAX_BODY_SIZE=1g
