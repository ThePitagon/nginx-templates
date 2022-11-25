#!/bin/bash

TYPE=$1
OUT=$2

chmod +x ./make.env.sh
source ./make.env.sh

export ROOT=${ROOT}
export DOMAIN=${DOMAIN}
export SERVER_NAME=${SERVER_NAME}
export HTTP_PORT=${HTTP_PORT}
export HTTPS_PORT=${HTTPS_PORT}
export SSL_CERTIFICATE=${SSL_CERTIFICATE}
export SSL_CERTIFICATE_KEY=${SSL_CERTIFICATE_KEY}
export PROXY_PASS=${PROXY_PASS}
export CLIENT_MAX_BODY_SIZE=${CLIENT_MAX_BODY_SIZE}

export host='$host'
export request_uri='$request_uri'
export uri='$uri'
export args='$args'

mkdir -p ${OUT}

envsubst < templates/${TYPE}.template.conf > ${OUT}/${DOMAIN}.conf
