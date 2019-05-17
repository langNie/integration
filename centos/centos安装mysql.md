## 1 下载mysql的repo源
wget http://repo.mysql.com/mysql80-community-release-el7-1.noarch.rpm

## 2 安装mysql-community-release-el7-5.noarch.rpm包
sudo rpm -ivh mysql80-community-release-el7-1.noarch.rpm

## 3 查看MySQL Yum存储库中的所有子存储库，并查看哪些子存储库已启用或禁用
yum repolist all | grep mysql

## 4 禁用8.0，启用5.7.23
sudo yum-config-manager --disable mysql80-community
sudo yum-config-manager --enable mysql57-community

找不到yum-config-manager命令
yum -y install yum-utils

## 手动编辑/etc/yum.repos.d/mysql-community.repo 文件来选择系列
找到要配置的子存储库的条目，然后编辑该enabled选项。指定 enabled=0禁用子存储库，enabled=1启用子存储库。例如，要安装MySQL 5.7，就把mysql8.0的enabled=1改为0，把mysql5.7的enabled改为=1。

## 3 安装mysql
sudo yum install mysql-community-server

## 4 重置密码
### 4.1 重置密码前，首先要登录
mysql -u root
登录时有可能报这样的错：ERROR 2002 (HY000): Can‘t connect to local MySQL server through socket ‘/var/lib/mysql/mysql.sock‘ (2)，原因是/var/lib/mysql的访问权限问题。下面的命令vim /etc/my.cnf
skip-grant-tables 

### 4.2 重启服务
sudo service mysqld restart

### 4.3 登录重置密码
mysql -u root
use mysql
update user set authentication_string=password('root') where user='root';
#
set global validate_password_policy=LOW;
set global validate_password_length=4;
<!-- alter user 'root'@'localhost' identified by 'root'; -->
flush privileges;

### 5 修改mysql字符集
show variables like '%character%';  查看字符集
vim /etc/my.cnf
character-set-server=utf8mb4
sudo service mysqld restart
