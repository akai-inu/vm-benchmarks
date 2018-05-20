#!/bin/bash

set -eu

# Usage: TEST_PATTERN="win10-hyperv" PROVIDER="hyperv" bash run-test.bash

TEST_ID="test-${TEST_PATTERN}-$(date +%y%m%d%H%M%S)"

CPU=1
MEMORY=1024

date +"%y-%m-%dT%H:%M:%S%z"
vagrant --version
git --version

git clone --depth 1 https://github.com/laravel/homestead.git "./${TEST_ID}"

cd ${TEST_ID}

git checkout -b v7.6.0 refs/tags/v7.6.0

tee ./Homestead.yaml <<EOS > /dev/null
---

name: "${TEST_ID}"
box: "laravel/homestead"
version: "6.0.0"
hostname: "${TEST_ID}"
ip: "autonetwork"
memory: "${MEMORY}"
cpus: "${CPU}"
provider: "${PROVIDER}"
databases:
    - homestead

EOS

cp ../Vagrantfile.template.rb ./Vagrantfile

vagrant up

cat <<EOS

ベンチマークの準備が完了しました。

`vagrant ssh` して `bash benchmark.bash` をたたいてください。結果が出力されます。

仮想環境はそのままになっているので、不要な場合は自分で "vagrant destroy --force" などしてください。

EOS
