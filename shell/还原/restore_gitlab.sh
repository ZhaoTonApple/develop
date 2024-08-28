#!/bin/bash

# 备份文件路径（请根据实际备份文件路径修改）
BACKUP_DIR="/opt/backup/gitlab"
BACKUP_FILE="gitlab_backup_20240828.tar.gz"

# 校验备份文件是否存在
if [ ! -f "$BACKUP_DIR/$BACKUP_FILE" ]; then
    echo "Error: Backup file $BACKUP_DIR/$BACKUP_FILE does not exist!"
    exit 1
fi

# 停止 GitLab 服务
echo "停止 GitLab 服务..."
sudo gitlab-ctl stop

if [ $? -ne 0 ]; then
    echo "停止GitLab服务失败. Exiting."
    exit 1
fi

# 解压备份文件到根目录
echo "Restoring backup from $BACKUP_FILE..."
sudo tar -xzf "$BACKUP_DIR/$BACKUP_FILE" -C /

if [ $? -ne 0 ]; then
    echo "解压文件失败. Exiting."
    exit 1
fi

# 确保解压后的文件具有正确的权限和所有权
echo "Setting permissions and ownership..."
sudo chown -R git:git /etc/gitlab
sudo chown -R git:git /var/opt/gitlab
sudo chown -R git:git /var/log/gitlab

if [ $? -ne 0 ]; then
    echo "权限添加失败. Exiting."
    exit 1
fi

# 重新配置 GitLab 以确保权限和设置正确
echo "Reconfiguring GitLab..."
sudo gitlab-ctl reconfigure

if [ $? -ne 0 ]; then
    echo "Failed to reconfigure GitLab. Exiting."
    exit 1
fi

# 启动 GitLab 服务
echo "启动 GitLab 服务"
sudo gitlab-ctl start

if [ $? -ne 0 ]; then
    echo "启动 GitLab 服务失败Exiting."
    exit 1
fi

# 检查 GitLab 服务状态
echo "检查 GitLab 服务状态"
sudo gitlab-ctl status

echo "GitLab 还原与重启 successfully."
