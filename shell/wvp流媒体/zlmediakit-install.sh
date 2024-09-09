FILE=/home/tuners/ZLMediaKit/release/linux/Debug/MediaServer
if test -f "$FILE"; then
    echo "zlmediakit已编译成功"
else

#--------开始编译安装流媒体ZLMediaKit-------
sudo yum -y install gcc
sudo yum -y install gcc-c++
sudo yum install libssl-dev
sudo yum install libsdl-dev
sudo yum install libavcodec-dev
sudo yum install libavutil-dev
sudo yum install ffmpeg
sudo yum install git -y
yum -y install openssl-devel


# 国内用户推荐从同步镜像网站gitee下载 ，  安装ZLMediaKit
cd /home/tuners
git clone --depth 1 https://gitee.com/xia-chu/ZLMediaKit
cd ZLMediaKit
# 千万不要忘记执行这句命令
git submodule update --init
mkdir build
cd build
cmake ..
make -j4

cd /home/tuners/ZLMediaKit/
chmod -R 777 /home/tuners/ZLMediaKit/
#以守护进程模式启动
cd /home/tuners/ZLMediaKit/release/linux/Debug/

sed -i '104c mediaServerId=FQ3TF8yT83wh5Wvz' /home/tuners/ZLMediaKit/release/linux/Debug/config.ini

cd /home/tuners/ZLMediaKit/release/linux/Debug/
./MediaServer -d &

#开机启动
touch startMediaServer.sh
echo "
#!/bin/bash
#chkconfig:  2345 81 96
#description: startMediaServer
cd /home/tuners/ZLMediaKit/release/linux/Debug
#以守护进程模式启动
./MediaServer -d &
">>startMediaServer.sh

cp /home/tuners/ZLMediaKit/release/linux/Debug/startMediaServer.sh /etc/rc.d/init.d
#增加脚本的可执行权限
chmod +x /etc/rc.d/init.d/startMediaServer.sh
#添加脚本到开机自动启动项目中
cd /etc/rc.d/init.d
chkconfig --add startMediaServer.sh
chkconfig startMediaServer.sh on
#关闭防火墙
systemctl stop firewalld.service
systemctl disable firewalld.service

#--------结束编译安装流媒体------
fi