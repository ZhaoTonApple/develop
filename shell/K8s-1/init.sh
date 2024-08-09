# 以下是init.sh的内容  自行copy
#!/bin/bash
systemctl stop firewalld && systemctl disable firewalld
systemctl disable firewalld && systemctl stop firewalld
sed -i s/SELINUX=enforcing/SELINUX=disabled/g /etc/selinux/config
curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
sed -i -e '/mirrors.cloud.aliyuncs.com/d' -e '/mirrors.aliyuncs.com/d' /etc/yum.repos.d/CentOS-Base.repo
yum makecache

yum install -y wget
wget -O /etc/yum.repos.d/epel.repo https://mirrors.aliyun.com/repo/epel-7.repo
yum makecache
yum install yum-utils ipvsadm telnet wget net-tools conntrack ipset jq iptables  sysstat libseccomp socat nfs-utils fuse lvm2 device-mapper-persistent-data fuse-devel ceph-common tree vim lrzsz -y
yum install -y ntp
# vim /etc/chrony.conf
mv /etc/chrony.conf  /etc/chrony.conf.bak

cat >/etc/chrony.conf<< EOF
server ntp.aliyun.com iburst
stratumweight 0
driftfile /var/lib/chrony/drift
rtcsync
makestep 10 3
bindcmdaddress 127.0.0.1
bindcmdaddress ::1
keyfile /etc/chrony.keys
commandkey 1
generatecommandkey
logchange 0.5
logdir /var/log/chrony
EOF

rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm
yum --enablerepo="elrepo-kernel" list --showduplicates | sort -r | grep kernel-ml.x86_64
yum --enablerepo="elrepo-kernel" list --showduplicates | sort -r | grep kernel-lt.x86_64
yum --enablerepo=elrepo-kernel install kernel-ml-devel kernel-ml -y
awk -F\' '$1=="menuentry " {print $2}' /etc/grub2.cfg
grub2-set-default 0
shutdown -r  now
