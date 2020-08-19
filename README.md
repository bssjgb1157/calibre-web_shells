## Calibre-web_shells

calibre-web一键安装脚本。
本脚本在Debian9(ARMv7l, ARM64)、Debian10(AMD64)、Cent OS8.2(ARM64)测试通过。
本脚本支持Debian和Redhet衍生的发行版系统(Ubuntu、Cent OS等)。
2020.8.18 本脚本支持Termux。

## Install

```
chmod 777 ./installer.sh
source ./installer.sh
```

## Usage
```
lcali
```                
    
Open your Web Browser
 ```
 ip:8083
 ```
 Next step, setting database.

## Install on Termux

安装时需要挂梯子，从打开Termux那刻起。

```
pkg install wget openssl-tool proot -y && hash -r && wget https://raw.githubusercontent.com/EXALAB/AnLinux-Resources/master/Scripts/Installer/Debian/debian.sh && bash debian.sh

./start-debian.sh
```

之后安装步骤同Debian的安装步骤。只是每次启动时需要先执行./start-debian.sh 。

同一局域网（WLAN热点也可以）下的任何设备可打开在Termux上安装的Calibre 。

