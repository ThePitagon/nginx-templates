#!/bin/bash
#
# @author: Travis Tran
# @website: https://truong.id
# @notice: run as root

# Setup environment
chmod +x ./env.sh
source ./env.sh

cd "${NGINX_DIR}" || exit
mkdir sites ssl
sudo openssl dhparam -out "${NGINX_DIR}/ssl/dhparam.pem" 2048
sudo openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout "${NGINX_DIR}/ssl/selfsigned.key" -subj "${SSL_SUBJ}" -out "${NGINX_DIR}/ssl/selfsigned.crt"
yes | sudo cp -R html "${NGINX_HTML_DIR}"
yes | sudo cp -R conf.d "${NGINX_DIR}/"
yes | sudo cp -R includes "${NGINX_DIR}/"
yes | sudo cp -R *.sh "${NGINX_DIR}/"
sudo chown -R ${NGINX_USER}. "${NGINX_DIR}" "${NGINX_HTML_DIR}"
sudo systemctl restart nginx
