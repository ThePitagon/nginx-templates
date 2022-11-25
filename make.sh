#!/bin/bash

chmod +x ./make.env.sh
source ./make.env.sh

envsubst < app.template.conf > app.conf
