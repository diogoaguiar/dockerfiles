FROM php:8.1-apache


#############################
### Server configurations ###
#############################

# Install updates
RUN apt update && \
    apt upgrade -y

# Configure user
ENV USER=app-user
ENV GROUP=app-user
ENV USER_ID=1000
ENV GROUP_ID=1000

RUN groupadd -r -g $GROUP_ID $GROUP && \
    useradd -rm -g $GROUP -u $USER_ID $USER

# Configure source directory
ENV SOURCE_DIR=/app

RUN mkdir -p $SOURCE_DIR && \
    chown $USER:$GROUP $SOURCE_DIR

VOLUME $SOURCE_DIR
WORKDIR $SOURCE_DIR

# Exposed ports
EXPOSE 80


##########################
### PHP configurations ###
##########################

# Set php.ini file
RUN cp "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Download ca certificates bundle
RUN apt update && \
    apt install wget -y && \
    wget -P $PHP_INI_DIR https://curl.haxx.se/ca/cacert.pem && \
    apt remove wget -y && \
    apt autoremove -y

# Set updated certificate files
RUN sed -ri -e "s|;openssl.cafile=|openssl.cafile=$PHP_INI_DIR/cacert.pem|g" $PHP_INI_DIR/php.ini && \
    sed -ri -e "s|;curl.cainfo =|curl.cainfo=$PHP_INI_DIR/cacert.pem|g" $PHP_INI_DIR/php.ini && \
    sed -ri -e "s|;openssl.capath=|openssl.capath=/etc/ssl/certs/|g" $PHP_INI_DIR/php.ini

# Increase max_input_vars
RUN sed -ri -e "s|;max_input_vars = 1000|max_input_vars = 5000|g" $PHP_INI_DIR/php.ini

# Increase memory_limit
RUN sed -ri -e "s|memory_limit = 128M|memory_limit = 512M|g" $PHP_INI_DIR/php.ini

# Add php extensions
RUN apt update && \
    # bcmath (Mathematics)
    docker-php-ext-install bcmath && \
    # pdo_mysql (MySQL)
    docker-php-ext-install mysqli pdo pdo_mysql && \
    # intl (Internacionalization)
    apt install zlib1g-dev libicu-dev g++ -y && \
    docker-php-ext-configure intl && \
    docker-php-ext-install intl && \
    # gd (Image processing)
    apt install zlib1g-dev libjpeg62-turbo-dev libpng-dev libfreetype6-dev -y && \
    docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ && \
    docker-php-ext-install gd && \
    # pcntl (Process Control)
    docker-php-ext-install pcntl && \
    # pdo_sqlsrv (SQL Server)
    apt install unixodbc-dev gnupg2 -y && \
    curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/debian/11/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
    apt-get update && \
    ACCEPT_EULA=Y apt-get install -y  && \
    ACCEPT_EULA=Y apt-get install msodbcsql17 -y && \
    pecl install sqlsrv && \
    pecl install pdo_sqlsrv && \
    docker-php-ext-enable sqlsrv && \ 
    docker-php-ext-enable pdo_sqlsrv

# Install composer
RUN curl -fsSL  https://raw.githubusercontent.com/composer/getcomposer.org/76a7060ccb93902cd7576b67264ad91c8a2700e2/web/installer | php -- && \
    mv composer.phar /usr/local/bin/composer


#############################
### Apache configurations ###
#############################

# Set user and group to be used by apache
ENV APACHE_RUN_USER=$USER
ENV APACHE_RUN_GROUP=$GROUP

# Update apache configuration to match Laravel's structure
ENV APACHE_DOCUMENT_ROOT=$SOURCE_DIR/public
RUN sed -ri -e "s|/var/www/html|$APACHE_DOCUMENT_ROOT|g" /etc/apache2/sites-available/*.conf && \
    sed -ri -e "s|/var/www/|$APACHE_DOCUMENT_ROOT|g" /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Enable apache modules
RUN a2enmod rewrite && \
    a2enmod headers


###########################
### Node configurations ###
###########################

# Install node and npm
# RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && \
#     apt install -y nodejs

# Install Puppeteer
# RUN npm install -g puppeteer
# RUN apt update && \
#     apt install chromium -y


############################
### Build configurations ###
############################

# Copy source (uncomment for standalone image)
# COPY --chown=$APACHE_RUN_USER:$APACHE_RUN_GROUP . $SOURCE_DIR/
# RUN cp $SOURCE_DIR/.env.example $SOURCE_DIR/.env


############################
