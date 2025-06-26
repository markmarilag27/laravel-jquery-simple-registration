# ---------------------------------------
# Stage 1: Build Laravel dependencies
# ---------------------------------------
FROM php:8.4-fpm-alpine AS build

ARG USER_ID=1000
ARG GROUP_ID=1000

# Install build dependencies
RUN apk add --no-cache --virtual .build-deps \
    git \
    curl \
    zip \
    unzip \
    libzip-dev \
    oniguruma-dev \
    icu-dev \
    libxml2-dev \
    mysql-dev \
    bash \
    shadow \
    && docker-php-ext-install \
        pdo \
        pdo_mysql \
        mbstring \
        bcmath \
        zip \
        exif \
        pcntl \
        intl \
    && docker-php-ext-enable opcache \
    && apk del .build-deps \
    && rm -rf /var/cache/apk/* /tmp/*

# Install Composer globally
COPY --from=composer:2.7 /usr/bin/composer /usr/local/bin/composer

# Set working directory
WORKDIR /var/www/html

# ---------------------------------------
# Stage 2: Runtime with Laravel user
# ---------------------------------------
FROM php:8.4-fpm-alpine

ARG USER_ID=1000
ARG GROUP_ID=1000
ENV APP_USER=laravel
ENV CI=true

# Install runtime dependencies
RUN apk add --no-cache \
    nginx \
    curl \
    mysql-client \
    icu-libs \
    libzip \
    supervisor \
    bash \
    shadow \
    git \
    openssh \
    && rm -rf /var/cache/apk/* /tmp/*

# Create non-root user
RUN addgroup -g ${GROUP_ID} ${APP_USER} \
    && adduser -D -u ${USER_ID} -G ${APP_USER} ${APP_USER}

RUN mkdir -p /home/laravel/.ssh && \
    chown -R ${APP_USER}:${APP_USER} /home/laravel/.ssh

# Create Laravel directories and fix permissions
RUN mkdir -p /var/www/html/storage /var/www/html/bootstrap/cache \
    && mkdir -p /var/log/php /var/log/nginx /run /var/lib/nginx /tmp/laravel/storage/framework/views \
    && chown -R ${APP_USER}:${APP_USER} \
        /var/www/html \
        /var/log/php \
        /var/log/nginx \
        /run \
        /var/lib/nginx \
        /tmp/laravel/storage/framework/views \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Copy built PHP extensions and application code
COPY --from=build /usr/local/lib/php/extensions /usr/local/lib/php/extensions
COPY --from=build /usr/local/etc/php/conf.d /usr/local/etc/php/conf.d
COPY --from=build /usr/local/bin/composer /usr/local/bin/composer
COPY --from=build /var/www/html /var/www/html

# Copy nginx config
COPY nginx.conf /etc/nginx/http.d/default.conf

# Copy your custom php.ini
COPY php.ini /usr/local/etc/php/php.ini

# Set working directory
WORKDIR /var/www/html

# Set user
USER ${APP_USER}

# Expose HTTP port
EXPOSE 80

# Start services
CMD ["sh", "-c", "php-fpm & nginx -g 'daemon off;'"]
