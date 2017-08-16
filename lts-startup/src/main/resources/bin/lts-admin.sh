#!/usr/bin/env bash

# JVMFLAGS JVM参数可以在这里设置
JVMFLAGS=-Dfile.encoding=UTF-8

# 项目名
LTS_POJ_NAME=lts-admin

# 启动方法
LTS_MAIN="com.github.ltsopensource.startup.admin.JettyContainer"

# 环境参数
ENV_NAME="$1"

FILE_PATH=$(cd "$(dirname "$0")"; pwd)
LTS_HOME=${FILE_PATH%/bin*}
LTS_LOG_DIR=${LTS_HOME}/../stat-logs/${LTS_POJ_NAME}
LTS_LOG_FILE=${LTS_LOG_DIR}/${LTS_POJ_NAME}-${ENV_NAME}-`date +'%Y%m%d%H%M%S'`.log
LTS_LOG_LINK=${LTS_LOG_DIR}/${LTS_POJ_NAME}-${ENV_NAME}-latest
LTS_PID_DIR=${LTS_HOME}/../pid
LTS_PID_FILE=${LTS_PID_DIR}/${LTS_POJ_NAME}-${ENV_NAME}.pid
LTS_CONF_DIR=${LTS_HOME}/conf/${ENV_NAME}
LTS_WAR_DIR=${LTS_HOME}/war
LTS_LIB_DIR=${LTS_WAR_DIR}/jetty/lib

mkdir -p ${LTS_LOG_DIR}
mkdir -p ${LTS_PID_DIR}


if [ "$JAVA_HOME" != "" ]; then
  JAVA="$JAVA_HOME/bin/java"
else
  JAVA=java
fi

#把lib下的所有jar都加入到classpath中
for i in "$LTS_LIB_DIR"/*.jar
do
	CLASSPATH="$i:$CLASSPATH"
done

case $2 in
start)
    echo "Starting $LTS_POJ_NAME [$ENV_NAME]  ... "
    if [ -f "$LTS_PID_FILE" ]; then
      if kill -0 `cat "$LTS_PID_FILE"` > /dev/null 2>&1; then
         echo ${LTS_POJ_NAME} already running as process `cat "$LTS_PID_FILE"`.
         exit 0
      fi
    fi
    nohup "$JAVA" -cp "$CLASSPATH" ${JVMFLAGS} ${LTS_MAIN} "$LTS_CONF_DIR" "$LTS_WAR_DIR" > "$LTS_LOG_FILE" 2>&1 < /dev/null &

    if [ $? -eq 0 ]; then
      if /bin/echo -n $! > "$LTS_PID_FILE"; then
        sleep 1
        rm -f ${LTS_LOG_LINK}
        ln -sv ${LTS_LOG_FILE} ${LTS_LOG_LINK}
        echo "STARTED"
      else
        echo "FAILED TO WRITE PID"
        exit 1
      fi
    else
      echo "$LTS_POJ_NAME DID NOT START"
      exit 1
    fi
;;
restart)
    sh $0 $1 stop
    sleep 3
    sh $0 $1 start
;;
stop)
    echo "Stopping $LTS_POJ_NAME [$ENV_NAME]   ... "
    if [ ! -f "$LTS_PID_FILE" ]
    then
      echo "no $LTS_POJ_NAME to started (could not find file $LTS_PID_FILE)"
    else
      kill -9 $(cat "$LTS_PID_FILE")
      rm "$LTS_PID_FILE"
      echo "STOPPED"
    fi
    exit 0
;;
*)
    echo "Usage: $0 {env_name} {start|stop|restart}" >&2
esac