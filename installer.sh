#!/bin/bash 
set -e
##g
env(){
touch env.sh
chmod 777 env.sh
 echo "#!/bin/bash" >> ./env.sh
 echo "echo 请访问ip:8083" >> ./env.sh
 echo "cd /usr/lib/calibre-web-master && python3 cps.py" >> ./env.sh
 ln -s ./env.sh ./lcali
 cp ./lcali /bin
 cp ./lcali /sbin
 cp ./lcali /usr/bin
 cp ./lcali /usr/sbin
}

checksystem(){
	if [ -e /bin/yum ];then
		$1
	else
		$2
	fi
}

fail()                                                        {
        if [ $? -eq 1 ];then                                                  echo "安装失败!"                             
		exit 1
		fi
	}		

pipinstall(){
		pip3 install --target vendor -r requirements.txt
		fail
		rm -rf /usr/lib/cali.zip
		env
		echo " 安装完成!输入命令lcali即可启动。
	               如需后台运行请键入命令【nohup lcali &】
	              如需开机启动请自行将以上命令加入开机启动脚本中。
             	现在，请启动cali,然后在web浏览器输入【ip地址:8083】即可进入数据库设置界面。"	
	}
cont(){
	if [ $? -eq 1 ];then
		echo "Calibre-web下载失败!请手动访问https://github.com/janeczku/calibre-web下载!下载完成之后，请将未解压的文件与此脚本放在同一文件夹内，然后再执行此脚本。"
		exit 1 
	elif [ -e /usr/lib/calibre-web-master/  ];then
		cd /usr/lib/calibre-web-master
	fi
	pipinstall
} 

checksystem 'yum update -y' 'apt update -y'
echo " 注意事项：如果您的服务器在中国大陆，在开始安装Calibre-web之前，请确认您已修改hosts并且可加速解析访问GitHub。如果您未修改hosts，请在安装程序执行之前将其修改，或者使用代理软件代理Wget。 Calibre将被安装在本目录下。【按Ctrl-C退出；按任意键继续。】"
read continue_
#### download and install calibre-web ####
download()
{
       	cd /usr/lib
	      if [ -e /usr/lib/.pip/ ];then     
		      rm -rf /usr/lib/.pip/pip.conf
		      touch /usr/lib/.pip/pip.conf  
		      echo [global] >> /usr/lib/.pip/pip.conf 
		      echo trusted-host = pypi.douban.com >> /usr/lib/.pip/pip.conf  
		      echo index-url = http://pypi.douban.com/simple >> /usr/lib/.pip/pip.conf   
	      else    
	      mkdir /usr/lib/.pip/
		      > /usr/lib/.pip/pip.conf 
		      echo [global] >> /usr/lib/.pip/pip.conf 
		      echo trusted-host = pypi.douban.com >> /usr/lib/.pip/pip.conf  
		      echo index-url = http://pypi.douban.com/simple >> /usr/lib/.pip/pip.conf   
	      fi
	      more /usr/lib/.pip/pip.conf
	fail
	if [ -e /usr/bin/wget -a /usr/bin/unzip ];then
		wget https://github.com/janeczku/calibre-web/archive/master.zip -O cali.zip
	        unzip /usr/lib/cali.zip
		cont
	else
checksystem 'yum install wget -y' 'apt install wget -y'
checksystem 'yum install unzip -y' 'apt install unzip -y'
		wget https://github.com/janeczku/calibre-web/archive/master.zip -O cali.zip
	unzip /usr/lib/cali.zip	
       cont
	fi
		}
#### install pip ####
pip()
{
	if [ -e /usr/bin/pip -a /usr/bin/pip3 ];then
		download
	else
  checksystem download 'apt-get install python-pip -y'
checksystem 'yum install python3-pip -y' 'apt-get install python3-pip -y'
	download
fi
}
	
#### install git ####
gits()
{
if [ -e  /usr/lib/git-core  ];then
	pip
else
checksystem 'yum install git -y' 'apt-get install git -y'
	pip
fi
}

makepython(){
yum groupinstall -y 'development tools'
yum install -y zlib-devel bzip2-devel openssl-devel xz-libs wget
wget http://www.python.org/ftp/python/2.7.13/Python-2.7.13.tar.xz
xz -d Python-2.7.13.tar.xz
tar -xvf Python-2.7.13.tar
rm -rf Python-2.7.13.tar.xz
cd Python-2.7.13
./configure --prefix=/usr/local
make
make altinstall
wget --no-check-certificate https://pypi.python.org/packages/source/s/setuptools/setuptools-1.4.2.tar.gz
tar -xzvf setuptools-1.4.2.tar.gz
rm -rf setuptools-1.4.2.tar.gz
cd setuptools-1.4.2
python2.7 setup.py install
curl  https://bootstrap.pypa.io/get-pip.py | python2.7
gits
}

debian(){
if [  -e /usr/lib/python3/ -a /usr/lib/python2.7/ ];then
	gits
else
apt-get install python3
gits
fi
}
centos(){
if [ -e /usr/local/bin/python2.7 ];then
	gits
else
yum install python3 -y
makepython
fi
}
#### install python ####
checksystem centos debian
##by bssjgb1157 2020.2

