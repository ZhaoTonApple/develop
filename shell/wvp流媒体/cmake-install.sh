if type -p  cmake; then
   echo "cmake has been installed."
else

sudo yum -y install gcc
sudo yum -y install gcc-c++
sudo yum install libssl-dev
sudo yum install libsdl-dev
sudo yum install libavcodec-dev
sudo yum install libavutil-dev
sudo yum install ffmpeg
sudo yum install git -y
yum -y install openssl-devel

#安装cmake
cd /home/tuners
git clone https://gitee.com/zenglg/cmake_release.git
chmod 777 -R cmake_release
cd /home/tuners/cmake_release/cmake-3.16.2
./bootstrap --prefix=/usr --datadir=share/cmake --docdir=doc/cmake && make
sudo make install
hash -r
cmake --version
fi