#!/usr/bin/env bash

set -x

VERSION="1.6.9"

LTS_BIN="${BASH_SOURCE-$0}"
LTS_BIN="$(dirname "${LTS_BIN}")"
LTS_BIN_DIR="$(cd "${LTS_BIN}"; pwd)"

cd ${LTS_BIN_DIR}

mvn clean install -U -DskipTests

DIST_DIR="$LTS_BIN_DIR/dist"
DIST_BIN_DIR="$DIST_DIR/lts-$VERSION-bin"
DIST_LTS_LIB_DIR="$DIST_DIR/lts-$VERSION-lib-output"

mkdir -p ${DIST_BIN_DIR}
mkdir -p ${DIST_LTS_LIB_DIR}

#DIST_BIN_DIR="$(cd "$(dirname "${DIST_BIN_DIR}/.")"; pwd)"
#mkdir -p ${DIST_BIN_DIR}

# 打包
STARTUP_DIR="$LTS_BIN_DIR/lts-startup/"
cd ${STARTUP_DIR}
mvn clean assembly:assembly -DskipTests -Pdefault

cp -rf ${STARTUP_DIR}/target/lts-bin/lts/* ${DIST_BIN_DIR}

mkdir -p ${DIST_BIN_DIR}/war/jetty/lib
mvn clean assembly:assembly -DskipTests -Plts-admin
cp -rf ${STARTUP_DIR}/target/lts-bin/lts/lib  ${DIST_BIN_DIR}/war/jetty
cp -rf ${LTS_BIN_DIR}/lts-admin/target/lts-admin-${VERSION}.war ${DIST_BIN_DIR}/war/lts-admin.war

cd ${LTS_BIN_DIR}/dist
rm -f lts-${VERSION}-bin.zip
zip -r lts-${VERSION}-bin.zip lts-${VERSION}-bin/*

find ${LTS_BIN_DIR} | grep -E "lts-[a-z]*/target/lts-[a-z]*-1.6.9.jar$" | xargs -I{} cp -fp {} ${DIST_LTS_LIB_DIR}