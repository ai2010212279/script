#!/bin/sh
#export JAVA_HOME=/fqgj/soft/jdk1.7.0_67
#应用启动端口
port=8088
#应用所用tomcat所在路径或grep 关键字
tomcat_dir="/home/admin/tomcat"
#tomcat启动命令
start_cmd="/home/admin/tomcat/bin/startup.sh"
#tomcat结束命令
shutdown_cmd="/home/admin/tomcat/bin/shutdown.sh"
#check url
check_url="/ok"

#tomcat启动过程
pid=`netstat -anp| grep ${port} | awk '{print $7}' | awk -F "/" '{print $1}'`
echo "pid ${pid}"
if [ -n "${pid}" ];then
        ${shutdown_cmd}
        sleep 3
        check=`ps -ef | grep ${tomcat_dir} | grep -v "grep" | grep -v $0 | awk '{print $2}'`
        echo "check ${check}"
        if [ -n "${check}" ];then
                for id in ${check}
                do
                        kill -9 ${id}
                done
        fi
fi
${start_cmd}
sleep 2

#应用启动结果检查
for c in {1..20}
do
        response=$(curl "http://localhost:${port}${check_url}")
        echo "response:${response}"
        if [ "${response}" == '"ok"' ];then
                break
        fi
        sleep 5;
done