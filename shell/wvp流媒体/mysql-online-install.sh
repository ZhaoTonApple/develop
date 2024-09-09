#安装wget
if type -p  wget; then
   echo "wget has been installed."
else
   yum install wget  -y
fi


if type -p mysql; then
    echo "mysql has been installed."
else
    #开始安装mysql
    echo "Download msyql5.7 rpm..."
    # mkdir temp dir to use download data
    if [ ! -d "temp" ]; then
      echo "temp dir is not exits,create it!"
      sudo mkdir -p temp
    fi

    # dowload mysql5.7 to ../tmp/
    wget -P temp -i -c http://dev.mysql.com/get/mysql57-community-release-el7-10.noarch.rpm

    echo "Start to install mysql5.7..."
    sudo yum -y install temp/mysql57-community-release-el7-10.noarch.rpm
    rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022
    sudo yum -y install mysql-community-server

    echo "启动mysql 服务"
    sudo systemctl start mysqld.service

    SQL_VERSION=`mysql -V | grep -i -o -P '5.7'`
    if [ $SQL_VERSION == "5.7" ];then
        echo "check msyql install ok!"
    else
        echo -e "\033[31m Msyql install error, Please install it manually \033[0m"
        exit 0
    fi

    echo "msyql 临时密码:"
    grep 'password' /var/log/mysqld.log |head -n 1 |grep -oE "localhost:(.+)$" | grep -i -o -P 'localhost: \K.+'


    echo "try modify database use password"
    # get mysql temp password
    TEMP_PWD=`grep 'password' /var/log/mysqld.log |head -n 1 |grep -oE "localhost:(.+)$" | grep -i -o -P 'localhost: \K.+'`
    echo $TEMP_PWD


    # get mysql sock file
    SOCK=`netstat -ln | grep mysql | head -n 2 | awk '{print $9}'`
    PORT="3306"
    USER="root"
    # modify set your ownpwd
    PASSWORD="Tuners2012!@#"
    WRAPPWD="\"Tuners2012!@#\""

    # modify password
    mysql --connect-expired-password -p$TEMP_PWD -S $SOCK -e 'alter user user() identified by '$WRAPPWD

    echo "modify database password ok!"
    echo "new password: $PASSWORD"
    #mysql开启远程访问
    mysql  -uroot -p'Tuners2012!@#' -e"grant all privileges on *.* to 'root'@'%' identified by 'Tuners2012!@#';"
    mysql  -uroot -p'Tuners2012!@#' -e"flush privileges;"
    echo "开启远程访问"
    #关闭防火墙
systemctl stop firewalld.service
systemctl disable firewalld.service

fi