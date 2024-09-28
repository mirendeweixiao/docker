ARG NGINX_VERSION
FROM nginx:${NGINX_VERSION}

RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
        ln -sf /dev/stderr /var/log/nginx/error.log

WORKDIR /var/www/html
RUN usermod -u 1000 www-data && groupmod -g 1000 www-data

EXPOSE 80
EXPOSE 443