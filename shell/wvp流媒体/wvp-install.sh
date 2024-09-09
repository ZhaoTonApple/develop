#设置wvp服务器所在ip
wvp_server_ip="192.168.4.112"

#-------------------开始编译安装wvp——————————————————————————
#从gitee克隆wvp代码
cd /home/tuners
git clone https://gitee.com/zenglg/wvp-GB28181-pro.git

cd wvp-GB28181-pro/web_src/

#如果目录存在，则表示前端已编译成功
if [ ! -d "/home/tuners/wvp-GB28181-pro/src/main/resources/static" ]; then
      #编译前端页面
	npm --registry=https://registry.npm.taobao.org install
	npm run build
else
	echo "wvp前端已编译成功"
fi

FILE=/home/tuners/wvp-GB28181-pro/target/wvp-pro.jar
if test -f "$FILE"; then
    echo "wvp后台已编译成功"
else

#进入wvp-GB28181-pro目录
cd ..
#打包后台项目, 生成可执行jar， 编译完成后在target目录下出现wvp-pro-***.jar。
mvn package
cd /home/tuners/wvp-GB28181-pro/target/
mv wvp-pro-*.jar wvp-pro.jar

fi


#拷贝配置文件
cp /home/tuners/wvp-GB28181-pro/src/main/resources/application-dev.yml /home/tuners/wvp-GB28181-pro/target/application.yml
cd /home/tuners/wvp-GB28181-pro/target
#修改配置文件
sed -i '10d' /home/tuners/wvp-GB28181-pro/target/application.yml
sed -i "10s/ /        host: ${wvp_server_ip}\n /"  /home/tuners/wvp-GB28181-pro/target/application.yml
sed -i '23d' /home/tuners/wvp-GB28181-pro/target/application.yml
sed -i "23s# #        url: jdbc:mysql://${wvp_server_ip}:3306/wvp?useUnicode=true\&characterEncoding=UTF8\&rewriteBatchedStatements=true\&serverTimezone=PRC\&useSSL=false\&allowMultiQueries=true\n #"  /home/tuners/wvp-GB28181-pro/target/application.yml
sed -i '52d' /home/tuners/wvp-GB28181-pro/target/application.yml
sed -i "52s/ /    ip: ${wvp_server_ip}\n/"  /home/tuners/wvp-GB28181-pro/target/application.yml
sed -i '69d' /home/tuners/wvp-GB28181-pro/target/application.yml
sed -i "69s/ /    ip: ${wvp_server_ip}\n/"  /home/tuners/wvp-GB28181-pro/target/application.yml
sed -i '71d' /home/tuners/wvp-GB28181-pro/target/application.yml
sed -i "71s/ /    http-port: 80\n /"  /home/tuners/wvp-GB28181-pro/target/application.yml
sed -i '16d' /home/tuners/wvp-GB28181-pro/target/application.yml
sed -i "16s/ /        password: Tuners2012!@#\n /"  /home/tuners/wvp-GB28181-pro/target/application.yml
sed -i '25d' /home/tuners/wvp-GB28181-pro/target/application.yml
sed -i "25s/ /        password: Tuners2012!@#\n /"  /home/tuners/wvp-GB28181-pro/target/application.yml
#关闭防火墙
systemctl stop firewalld.service
systemctl disable firewalld.service

#创建数据库、执行sql脚本
mysql  -uroot -p'Tuners2012!@#' -e"create database wvp DEFAULT CHARACTER SET utf8 COLLATE utf8_bin;"
mysql  -uroot -p'Tuners2012!@#' -e"source /home/tuners/wvp-GB28181-pro/sql/mysql.sql"
mysql  -uroot -p'Tuners2012!@#' -e"flush privileges;"

java -jar /home/tuners/wvp-GB28181-pro/target/wvp-pro*.jar --spring.config.location=/home/tuners/wvp-GB28181-pro/target/application.yml