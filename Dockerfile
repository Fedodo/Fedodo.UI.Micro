FROM nginx:stable-alpine

COPY ./deployment/nginx.conf /etc/nginx/nginx.conf

COPY ./build/web /usr/share/nginx/html/