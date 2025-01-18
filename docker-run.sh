#!/bin/bash

docker run -d \
-p 80:80 \
-v ${PWD}/.env:/var/www/html/.env \
-v app_logs:/var/www/html/storage/logs \
filament

#docker run -d -p 80:80 -v ${PWD}/logs:/var/www/html/storage/logs filament
#docker run -d -p 80:80 -v app_logs:/var/www/html/storage/logs filament
#docker run -d -p 80:80 filament
