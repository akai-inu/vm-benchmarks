#!/bin/bash

set -exu

sudo apt update

sudo apt install -y php7.2-cli php7.2-bcmath php7.2-curl php7.2-gd php7.2-mbstring php7.2-mysql php7.2-opcache php7.2-xsl

EXPECTED_SIGNATURE="$(wget -q -O - https://composer.github.io/installer.sig)"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_SIGNATURE="$(php -r "echo hash_file('SHA384', 'composer-setup.php');")"

if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]
then
    >&2 echo 'ERROR: Invalid installer signature'
    rm composer-setup.php
    exit 1
fi

sudo php composer-setup.php --quiet --install-path=/usr/local/bin --filename=composer
rm composer-setup.php
