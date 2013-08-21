#!/bin/bash

BASE=$(cd $(dirname $0) && /bin/pwd)

err() { echo 1>&2 "ERROR: $@"; exit 1; }

mode=$1

set -e
BUILD_OK=false
BUILD_ERR="Internal error"
trap '$BUILD_OK || err "${BUILD_ERR}"' 0

function reset_db() {
  cd ${BASE}/vnet
  bundle exec rake db:drop
  bundle exec rake db:create
  bundle exec rake db:migrate
}


case ${mode} in
  install-deps::rhel)
    yum install -y install wakame-vdc-ruby redis mysql-server \
    make git gcc gcc-c++ zlib-devel openssl-devel zeromq-devel \
    mysql-devel sqlite-devel libpcap-devel
    BUILD_OK=true
    ;;
  install)
    make install
    reset_db
    BUILD_OK=true
    ;;
  reset-db)
    reset_db
    BUILD_OK=true
    ;;
  bundle)
    make install-bundle-dev
    BUILD_OK=true
    ;;
  *)
    BUILD_ERR="Unknown option: ${mode}"
    ;;
esac
