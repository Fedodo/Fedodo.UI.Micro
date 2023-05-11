FROM nginx:latest

COPY ./deployment/nginx.conf /etc/nginx/nginx.conf

COPY ./build/web /usr/share/nginx/html/