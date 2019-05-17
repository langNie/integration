#!/bin/bash
# 配合执行微服务启动/停止/重启等功能
# 请确保微服务的jar包和脚本处于同一目录下

status() {
    local pid=-1
    if [[ $_type == "jar" ]] ; then
        pid=$(ps -ef | grep -E 'java' | grep -v 'grep' | grep $_service | grep -v '/bin/sh' | awk '{print $2}')
    else
        # 没有相关的java进程, 查看是否有node进程
        pid=$(pm2 ls | grep $_service_name | awk '{print $4}')
    fi
    if [ -z "$pid" ] ; then
        pid=-1
    fi
    echo $pid
}

start() {
    if [ -1 -ne $_pid ] ; then 
        echo "服务已启动"
        return
    fi
    # 启动服务
    echo -n "正在启动服务..."
    if [[ $_type == "jar" ]] ; then
        java -Dspring.profiles.active=prod -jar $_service > /dev/null 2>&1 &
    else
        rm -rf $_service_name
        tar -xzf $_service
        cd $_service_name
        pm2 start npm --name $_service_name --max-memory-restart 1024M -- run start
    fi
    echo "启动服务已完成"
}

stop() {
    if [ -1 -eq $_pid ] ; then
        echo "服务已停止"
        return
    fi
    echo -n "正在停止服务..."
    if [[ $_type == "jar" ]] ; then
        kill $_pid &
    else
        pm2 delete $_pid
    fi
    echo "停止服务已完成"
}

restart() {
    stop
    sleep 5s
    _pid=$(status)
    start
}

cd `dirname $0`

_count=$(find `pwd` -name "*.jar" -o -name "*.gz" | wc -l)
echo "脚本所在路径发现${_count}个服务, 请指定版本:"
select _service in `ls *.jar *.tar.gz 2>/dev/null` ;
do
    # 获取绝对路径
    echo "开始部署服务: $_service"
    break
done

# 获取服务名
_service_name=${_service%-*}
# 获取服务类型
_type=${_service##*.}
# 获取当前运行服务的pid
_pid=$(status)
# 获取运行环境
_env=$2
if [ -z "$_env" ] ; then 
    _env="dev"
fi

# Main logic, a simple case to call functions
case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        restart
        ;;
    *)
        echo "Usage: $0 {start|stop|restart} {dev|test|prod}"
        exit 1
esac