#--------------学习记录---------------------
#环境变量相关命令
#查看PATH值
#$echo PATH
#重设PATH值
#unset PATH
#将之前系统的PATH重新赋值给PATH
#export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin
#--------------学习记录---------------------


#1. 安装依赖 wget、vim、node、npm、maven、jdk
#安装wget
if type -p  wget; then
   echo "wget has been installed."
else
   yum install wget  -y
fi

#安装vim
if type -p  vim; then
   echo "vim has been installed."
else
  yum install vim  -y
fi


#安装node
#下载node、npm国内镜像（推荐）
# 判断是否安装了node
if type -p  node; then
   echo "node has been installed."
else
    mkdir /home/tuners
    cd /home/tuners
    wget https://npm.taobao.org/mirrors/node/v10.14.1/node-v10.14.1-linux-x64.tar.gz
#解压并重命名文件夹
    tar -xvf  node-v10.14.1-linux-x64.tar.gz
    rm -rf /usr/local/node
    mv -f node-v10.14.1-linux-x64 /usr/local/node

#设置环境变量，使其生效
# 检查原先是否已配置node环境变量
echo ${PATH}
checkNodeExist(){
 node1=$(grep -n "export NODE_HOME=/usr/local/node" /etc/profile | cut -f1 -d':')
    if [ -n "$node1" ];then
        sed -i "${node1}d" /etc/profile
    fi

 node2=$(grep -n "export PATH=\$NODE_HOME/bin:\$PATH" /etc/profile | cut -f1 -d':')
    if [ -n "$node2" ];then
        sed -i "${node2}d" /etc/profile
    fi
}
checkNodeExist
echo "export NODE_HOME=/usr/local/node" >> /etc/profile
source /etc/profile
echo ${PATH}
echo ${NODE_HOME}/bin
if [[ ${PATH} =~ ${NODE_HOME}/bin ]]; then
	echo " NODE_HOME has been set"
else
   echo "export PATH=\$NODE_HOME/bin:\$PATH" >> /etc/profile
   echo "setting NODE_HOME path successful."
fi

#保存刷新
source /etc/profile
echo ${PATH}
fi



#安装java
#!/bin/bash
if type -p java; then
    echo "Java has been installed."
else
#2.Installed Java  , must install wget
    wget -c https://repo.huaweicloud.com/java/jdk/8u151-b12/jdk-8u151-linux-x64.tar.gz;
    tar -zxvf ./jdk-8u151-linux-x64.tar.gz -C /usr/local/;
    mv /usr/local/jdk1.8.0_151  /usr/local/javaJDK;
#3.Configure environment variables
    echo "JAVA_HOME=/usr/local/javaJDK
    PATH=\$JAVA_HOME/bin:\$PATH
    CLASSPATH=\$JAVA_HOME/jre/lib/ext:\$JAVA_HOME/lib/tools.jar
    export PATH JAVA_HOME CLASSPATH" >> /etc/profile
    source /etc/profile
    echo "setting path successful."
    java -version
    echo "installed successful."
fi

if type -p mvn; then
    echo "maven has been installed."
else
    cd /home/tuners
    wget https://mirrors.tuna.tsinghua.edu.cn/apache/maven/maven-3/3.1.1/binaries/apache-maven-3.1.1-bin.tar.gz  --no-check-certificate
    tar vxf apache-maven-3.1.1-bin.tar.gz
    rm -rf /usr/local/maven3
    mv apache-maven-3.1.1 /usr/local/maven3

#设置mvn的环境变量
checkMvnExist(){
 mvn1=$(grep -n "MAVEN_HOME=.*" /etc/profile | cut -f1 -d':')
    if [ -n "$mvn1" ];then
        sed -i "${mvn1}d" /etc/profile
    fi
 mvn2=$(grep -n "export MAVEN_HOME" /etc/profile | cut -f1 -d':')
    if [ -n "$mvn2" ];then
        sed -i "${mvn2}d" /etc/profile
    fi
 mvn3=$(grep -n "export PATH=\${PATH}:\${MAVEN_HOME}/bin" /etc/profile | cut -f1 -d':')
    if [ -n "$mvn3" ];then
        sed -i "${mvn3}d" /etc/profile
    fi
}
checkMvnExist
echo ${PATH}
echo "MAVEN_HOME=/usr/local/maven3" >> /etc/profile
source /etc/profile
echo "export MAVEN_HOME" >> /etc/profile
if [[ ${PATH} =~ ${MAVEN_HOME}/bin ]]; then
	echo " MAVEN_HOME has been set"
else
   echo "export PATH=\${PATH}:\${MAVEN_HOME}/bin" >> /etc/profile
   echo "setting MAVEN_HOME path successful."
fi

#保存刷新
source /etc/profile
    echo ${PATH}
fi