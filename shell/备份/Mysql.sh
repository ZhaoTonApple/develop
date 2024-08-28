#!/bin/bash

# MySQL 用户名和密码
MYSQL_USER="root"
MYSQL_PASSWORD="123456"
DATABASE_NAME="recovery2"

# 备份目录和文件名
BACKUP_DIR="/backup/mysql"
CURRENT_DATE=$(date +"%Y%m%d")
BACKUP_FILE="${DATABASE_NAME}_backup_$CURRENT_DATE.sql"

# 创建备份目录（如果不存在）
mkdir -p $BACKUP_DIR

# 导出MySQL数据库
echo "Backing up MySQL database '$DATABASE_NAME'..."
mysqldump -u $MYSQL_USER -p$MYSQL_PASSWORD $DATABASE_NAME > $BACKUP_DIR/$BACKUP_FILE

# 检查备份是否成功
if [ $? -eq 0 ]; then
    echo "MySQL database backup completed: $BACKUP_DIR/$BACKUP_FILE"
else
    echo "MySQL database backup failed!"
fi

# 压缩备份文件
echo "Compressing the backup file..."
gzip $BACKUP_DIR/$BACKUP_FILE

# 检查压缩是否成功
if [ $? -eq 0 ]; then
    echo "Compression completed: $BACKUP_DIR/$BACKUP_FILE.gz"
else
    echo "Compression failed!"
fi
