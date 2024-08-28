#!/bin/bash

# 定义远程备份目录
REMOTE_BACKUP_DIR="/opt/backup"

# 删除超过两周的备份文件
echo "删除备份时间超过两周的备份文件."
find "$REMOTE_BACKUP_DIR" -type f -name "*.tar.gz" -mtime +14 -exec rm -f {} \;

# 检查删除操作是否成功
if [ $? -eq 0 ]; then
    echo "旧的备份文件删除成功."
else
    echo "旧的备份文件删除失败."
    exit 1
fi