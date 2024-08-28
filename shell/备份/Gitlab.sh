#!/bin/bash

# 定义备份目录和当前日期
BACKUP_DIR="/opt/backup/gitlab"
CURRENT_DATE=$(date +"%Y%m%d")

# 创建备份目录（如果不存在）
mkdir -p $BACKUP_DIR

# 定义备份文件名
BACKUP_FILE="gitlab_backup_$CURRENT_DATE.tar.gz"

# 停止GitLab服务
echo "Stopping GitLab services..."
sudo gitlab-ctl stop

# 检查是否成功停止服务
if [ $? -ne 0 ]; then
    echo "Failed to stop GitLab services. Exiting."
    exit 1
fi

# 备份所有目录到一个压缩文件中
echo "Backing up GitLab directories..."
sudo tar -czf "$BACKUP_DIR/$BACKUP_FILE" "${DIRECTORIES[@]}" --absolute-names --warning=no-file-changed

# 检查备份是否成功
if [ $? -eq 0 ]; then
    echo "Backup successful: $BACKUP_DIR/$BACKUP_FILE"
else
    echo "Backup failed!"
    sudo gitlab-ctl start
    exit 1
fi

# 启动GitLab服务
echo "Starting GitLab services..."
sudo gitlab-ctl start

# 检查是否成功启动服务
if [ $? -ne 0 ]; then
    echo "Failed to start GitLab services. Please check manually."
    exit 1
fi

# 归档所有备份文件到一个压缩包中
echo "Creating final backup archive..."
tar -czf $BACKUP_DIR/$BACKUP_FILE $BACKUP_DIR/etc_gitlab_$CURRENT_DATE.tar.gz $BACKUP_DIR/var_opt_gitlab_$CURRENT_DATE.tar.gz $BACKUP_DIR/var_log_gitlab_$CURRENT_DATE.tar.gz

# 删除中间备份文件
rm $BACKUP_DIR/etc_gitlab_$CURRENT_DATE.tar.gz $BACKUP_DIR/var_opt_gitlab_$CURRENT_DATE.tar.gz $BACKUP_DIR/var_log_gitlab_$CURRENT_DATE.tar.gz

echo "Backup completed: $BACKUP_DIR/$BACKUP_FILE"
