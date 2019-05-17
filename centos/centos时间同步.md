1. 安装ntpdate工具
# yum -y install ntp ntpdate

2. 设置系统时间与网络时间同步
# ntpdate cn.pool.ntp.org

2.1 查看时间是否已经与北京时间同步
# date

3. 将系统时间写入硬件时间
# hwclock --systohc

4. 强制系统时间写入CMOS中防止重启失效
## hwclock -w
　　或clock -w