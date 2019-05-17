## 下载安装包
wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u191-b12/2787e4a523244c269598db4e85c51e0c/jdk-8u191-linux-x64.tar.gz

## 解压安装包
tar zxvf  ./jdk-8u191-linux-x64.tar.gz

## 配置文件
vim  /etc/profile

JAVA_HOME=/usr/local/java/jdk1.8
JRE_HOME=/usr/local/java/jdk1.8/jre
PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin
CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar:$JRE_HOME/lib
export JAVA_HOME JRE_HOME PATH CLASSPATH

source /etc/profile