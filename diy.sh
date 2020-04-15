#!/bin/bash
#=================================================
# Description: DIY script
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
#=================================================
#echo '修改网关地址'
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate
cd package
mkdir openwrt-packages
cd openwrt-packages
git clone https://github.com/tzxiaozhen88/koolproxyR.git
git clone https://github.com/rufengsuixing/luci-app-adguardhome.git
git clone https://github.com/Lienol/openwrt-package.git
git clone https://github.com/vernesong/OpenClash.git
rm -rf luci-theme-argon 
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git

echo '修改默认主题'
sed -i 's/config internal themes/config internal themes\n    option Argon  \"\/luci-static\/argon\"/g' feeds/luci/modules/luci-base/root/etc/config/luci