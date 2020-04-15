#!/bin/bash
#=================================================
# Description: DIY script
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
#=================================================
# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate
cd package
mkdir openwrt-packages
cd openwrt-packages
git clone https://github.com/tzxiaozhen88/koolproxyR.git
git clone https://github.com/rufengsuixing/luci-app-adguardhome.git
git clone https://github.com/Lienol/openwrt-package.git
git clone https://github.com/vernesong/OpenClash.git