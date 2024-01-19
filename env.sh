#!/bin/bash
#
# @author: Travis Tran
# @website: https://truong.id
# @notice: run as root

# Default nginx directory
NGINX_DIR=/etc/nginx
# Default nginx user
NGINX_USER=admin
# Default nginx public html directory
NGINX_HTML_DIR=/usr/share/nginx/html
# Default subject for creating self-signed SSL
SSL_SUBJ="/C=VN/O=Pitagon/OU=Pitagon SSL/CN=*.pitagon.io"
