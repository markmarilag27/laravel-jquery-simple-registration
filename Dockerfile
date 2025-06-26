# Use the official PHP FPM Alpine image
FROM php:8.4-fpm-alpine

# metadata for filesystem permissions
ARG USER_ID=1000
ARG GROUP_ID=1000
ENV APP_USER=laravel

# 1) Install system packages: nginx, php extensions build deps, nodejs/npm
# 2) Install PHP extensions
# 3) Install global JS tooling (Yarn) via npm
# 4) Clean up caches
RUN apk add --no-cache \
      # runtime deps
      nginx \
      mysql-client \
      icu-libs \
      libzip \
      supervisor \
      bash \
      shadow \
      git \
      openssh \
      nodejs \
      npm \
      # build-time libs for PHP extensions
      oniguruma-dev \
      icu-dev \
      libxml2-dev \
      libzip-dev \
      # zip/unzip for composer & asset zips
      zip \
      unzip \
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
  && npm install -g yarn \
  && rm -rf /var/cache/apk/* /tmp/*

# Install Composer
COPY --from=composer:2.7 /usr/bin/composer /usr/local/bin/composer

# Create a non-root laravel user
RUN addgroup -g ${GROUP_ID} ${APP_USER} \
  && adduser -D -u ${USER_ID} -G ${APP_USER} ${APP_USER}

# Make Laravel directories & set permissions
RUN mkdir -p /var/www/html/storage /var/www/html/bootstrap/cache \
  && mkdir -p /var/log/php /var/log/nginx /run /var/lib/nginx \
  && chown -R ${APP_USER}:${APP_USER} \
      /var/www/html /var/log/php /var/log/nginx /run /var/lib/nginx \
  && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Copy in your application code
WORKDIR /var/www/html

# Copy configs
COPY nginx.conf /etc/nginx/http.d/default.conf
COPY php.ini     /usr/local/etc/php/conf.d/99-custom.ini

# Switch to non-root user
USER ${APP_USER}

# Expose & start
EXPOSE 80

CMD ["sh", "-c", "php-fpm & nginx -g 'daemon off;'"]
