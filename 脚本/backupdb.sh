#!/bin/sh

# create user 'backup'@'localhost' identified by 'backup';
# grant process,reload,lock tables,replication client on *.* to 'backup'@'localhost';
# flush privileges;

username="backup"
password="backup"
homeDir="/root/backup"
backup_full_file="backup_full"

today="$(date "+%Y%m%d")"
this_month="$(date "+%Y%m")"

day_backup(){
    echo "today=$today"
    if [ ! -d "$homeDir"/"$today" ]; then
        if [ ! -d "$homeDir"/"$backup_full_file" ]; then
            echo "全量备份中"
            xtrabackup --backup --target-dir="$homeDir"/"$backup_full_file" --user="$username" --password="$password"
        else
            echo "增量备份中"
            xtrabackup --backup --target-dir="$homeDir"/"$today" --incremental-basedir="$homeDir"/"$backup_full_file" --user="$username" --password="$password"
            echo "合并中"
            xtrabackup --prepare --apply-log-only --target-dir="$homeDir"/"$backup_full_file" --incremental-dir="$homeDir"/"$today"
        fi
    else
        echo "今天已经备份过了"
    fi
}

month_backup(){
    echo "this_month=$this_month"
    if [ ! -d "$homeDir"/"$this_month" ]; then
        echo "全量备份中"
        xtrabackup --backup --target-dir="$homeDir"/"$this_month" --user="$username" --password="$password"
    else
        echo "这月已经备份过了"
    fi
}

case "$1" in
    day)
        day_backup
        ;;
    month)
        month_backup
        ;;
    *)
        echo "参数错误"
esac
