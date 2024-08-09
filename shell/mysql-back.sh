#!/bin/bash

# 数据库连接信息
DB_USER="root"
DB_PASSWORD="root"
DB_HOST="127.0.0.1"
DB_NAME="recovery"

# 远程服务器信息
REMOTE_USER="root"
REMOTE_HOST="47.101.0.0"
REMOTE_BACKUP_DIR="/usr/local/mysql/back"

# 备份文件名和路径
BACKUP_DIR="/usr/local/mysql/back"
mkdir -p "$BACKUP_DIR" # 创建备份目录，如果不存在

BACKUP_FILE="$BACKUP_DIR/$(date +%Y%m%d_%H%M%S)_$DB_NAME.sql"

# 执行mysqldump命令
/usr/bin/mysqldump --user=$DB_USER --password=$DB_PASSWORD --host=$DB_HOST $DB_NAME > $BACKUP_FILE

# 检查备份文件是否创建成功
if [ $? -eq 0 ]; then
    echo "Backup completed successfully."

    # 使用scp推送备份文件到远程服务器
    scp $BACKUP_FILE $REMOTE_USER@$REMOTE_HOST:$REMOTE_BACKUP_DIR

    # 检查scp命令是否成功执行
    if [ $? -eq 0 ]; then
        echo "Backup file has been transferred to the remote server successfully."
    else
        echo "Transfer of backup file to the remote server failed."
    fi
else
    echo "Backup failed."
fi