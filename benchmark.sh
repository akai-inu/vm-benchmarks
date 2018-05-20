#!/bin/bash

set -exu

# git clone, composer install と phpunit

# homestead の場合に PHP のバージョンを変更
sudo update-alternatives --set php /usr/bin/php7.2 || true

sudo apt install php-redis -y

rm -rf framework

php -v
php -m
composer -V
git --version

time git clone https://github.com/laravel/framework.git

cd framework

time git checkout -b v5.6.22 refs/tags/v5.6.22

composer clear-cache

time composer install --optimize-autoloader --no-suggest --no-ansi --no-progress --profile

time ./vendor/bin/phpunit || true

# fio によるディスクベンチマーク
# @link https://buty4649.hatenablog.com/entry/2015/02/09/fio%E3%81%A7CrystalDiskMark%E3%81%A3%E3%81%BD%E3%81%84%E8%A8%88%E6%B8%AC%E3%82%92%E8%A1%8C%E3%81%86%E3%82%B3%E3%83%9E%E3%83%B3%E3%83%89%E3%82%92%E4%BD%9C%E3%81%A3%E3%81%9F
sudo apt update 
sudo apt install fio -y

cat <<EOS | fio -
[global]
ioengine=libaio
iodepth=1
size=1g
direct=1
runtime=60
directory=/home/vagrant
filename=.fio-diskmark

[Seq-Read]
bs=1m
rw=read
stonewall

[Seq-Write]
bs=1m
rw=write
stonewall

[Rand-Read-512K]
bs=512k
rw=randread
stonewall

[Rand-Write-512K]
bs=512k
rw=randwrite
stonewall

[Rand-Read-4K]
bs=4k
rw=randread
stonewall

[Rand-Write-4K]
bs=4k
rw=randwrite
stonewall

[Rand-Read-4K-QD32]
iodepth=32
bs=4k
rw=randread
stonewall

[Rand-Write-4K-QD32]
iodepth=32
bs=4k
rw=randwrite
stonewall
EOS