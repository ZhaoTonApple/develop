#1. 安装依赖 wget、vim、node、npm、maven、jdk
source /home/tuners/env-depends.sh
#2. 安装redis
sh redis-online-install.sh
#安装mysql
sh mysql-online-install.sh
#安装cmake
sh cmake-install.sh
#安装流媒体(包含配置文件修改)
sh zlmediakit-install.sh
#编译安装wvp（包含配置文件修改和数据库创建）
sh wvp-install.sh