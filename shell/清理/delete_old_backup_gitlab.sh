#!/bin/bash

# 备份目录
BACKUP_DIR="/opt/backup/gitlab"

# 删除超过两周的备份文件
echo "删除备份时间超过两周的Gitlab备份文件."
find "$BACKUP_DIR" -type f -name "*.tar.gz" -mtime +14 -exec rm -f {} \;

# 检查删除操作是否成功
if [ $? -eq 0 ]; then
    echo "旧的备份文件删除 successfully."
else
    echo "旧的备份文件未删除"
    exit 1
fi
