## 1、临时修改主机名：
[root@linux ]# hostname 主机名
修改只能临时有效，机器重启又还原了。

## 2、永久修改主机名：
修改hostname文件（路径：/etc/hostname）：
[root@linux ]# nano /etc/hostname
把hostname文件里面所有原来的名称改成你想改成的名称。
主机名同时也保存在/etc/hosts文件中，需要把当前IP地址对应的主机名修改为hostname文件中的名称。
然后重启机器：
[root@linux ]# reboot


## 3 修改服务器代号

vim /etc/hosts

127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6



## 4 修改dns

/etc/sysconfig/network-scripts