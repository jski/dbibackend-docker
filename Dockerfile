FROM nginx:alpine
LABEL maintainer="jski <blackdanieljames@gmail.com>"

COPY nginx/nginx.conf /etc/nginx/nginx.conf