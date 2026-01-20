FROM nginx:alpine
LABEL maintainer="jski <blackdanieljames@gmail.com>"

COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/validate-filenames.sh /docker-entrypoint.d/10-validate-filenames.sh
RUN chmod +x /docker-entrypoint.d/10-validate-filenames.sh
