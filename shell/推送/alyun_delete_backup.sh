#!/bin/bash

# 定义本地备份目录
LOCAL_BACKUP_DIRS=(
    "/opt/backup/mysql"
    "/opt/backup/gitlab"
)
REMOTE_USER="root"
REMOTE_HOST="47.0.0.109"
REMOTE_BACKUP_DIR="/opt/backup"

# 远程服务器上清理备份文件的脚本路径
REMOTE_CLEAN_SCRIPT="/path/to/clean_backup_script.sh"

# 遍历每个本地备份目录
for LOCAL_BACKUP_DIR in "${LOCAL_BACKUP_DIRS[@]}"; do
    # 获取最新的备份文件
    LATEST_BACKUP_FILE=$(ls -t $LOCAL_BACKUP_DIR/*.tar.gz | head -n 1)

    # 如果没有找到任何备份文件，则跳过该目录
    if [ -z "$LATEST_BACKUP_FILE" ]; then
        echo "没有找到最新的备份文件。"
        continue
    fi

    # 将备份文件复制到远程服务器
    echo "正在将最新的备份文件推送到远程服务器..."
    scp "$LATEST_BACKUP_FILE" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_BACKUP_DIR"

    # 检查文件传输是否成功
    if [ $? -eq 0 ]; then
        echo "最新的备份文件已成功推送到远程服务器。"
    else
        echo "推送最新的备份文件失败。"
        exit 1
    fi
done

# 调用远程服务器上的清理脚本
echo "正在远程服务器上清理超过两周的备份文件..."
ssh "$REMOTE_USER@$REMOTE_HOST" "$REMOTE_CLEAN_SCRIPT"

# 检查清理操作是否成功
if [ $? -eq 0 ]; then
    echo "远程服务器上的旧备份文件已成功清理。"
else
    echo "远程服务器上的旧备份文件清理失败。"
    exit 1
fi