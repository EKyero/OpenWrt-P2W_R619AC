#!/bin/bash
#=================================================
# Description: DIY script
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
#=================================================
git clone -b exp https://github.com/LGA1150/openwrt.git ../lga1150
git clone https://github.com/coolsnowwolf/lede.git ../lede
git clone https://github.com/x-wrt/x-wrt.git ../x-wrt
git clone -b openwrt-19.07 --single-branch https://github.com/project-openwrt/openwrt ../1907
mkdir package/ctcgfw
cp -r ../1907/package/ctcgfw/luci-app-adguardhome package
cp ../lga1150/package/firmware/ipq-wifi/board-p2w_r619ac.qca4019 package/firmware/ipq-wifi
cp ../x-wrt/package/firmware/wireless-regdb/patches/600-custom-fix-txpower-and-dfs.patch package/firmware/wireless-regdb/patches
cp ../x-wrt/package/kernel/ath10k-ct/patches/980-ath10k-poll-use-napi_complete_done.patch package/kernel/ath10k-ct/patches
cp ../x-wrt/package/kernel/mac80211/patches/ath/983-ath10k-allow-vht-on-2g.patch package/kernel/mac80211/patches/ath
cp ../x-wrt/package/kernel/mac80211/patches/ath/985-ath10k-use_napi_complete_done.patch package/kernel/mac80211/patches/ath
cp ../x-wrt/package/kernel/mac80211/patches/subsys/600-mac80211-allow-vht-on-2g.patch package/kernel/mac80211/patches/subsys
mkdir package/lean
cp -r ../lede/package/lean/automount package/lean
cp -r ../lede/package/lean/autosamba package/lean
cp -r ../lede/package/lean/coremark package/lean
cp -r ../1907/package/lean/luci-app-arpbind package/lean
cp -r ../1907/package/lean/luci-app-autoreboot package/lean
cp -r ../1907/package/lean/luci-app-cpufreq package/lean
cp -r ../1907/package/lean/luci-app-ramfree package/lean
mkdir -p package/luci-app-diskman && \
wget https://raw.githubusercontent.com/lisaac/luci-app-diskman/master/Makefile -O package/luci-app-diskman/Makefile
mkdir -p package/parted && \
wget https://raw.githubusercontent.com/lisaac/luci-app-diskman/master/Parted.Makefile -O package/parted/Makefile
mkdir -p package/luci-lib-docker && \
wget https://raw.githubusercontent.com/lisaac/luci-lib-docker/master/Makefile -O package/luci-lib-docker/Makefile
mkdir -p package/luci-app-dockerman && \
wget https://raw.githubusercontent.com/lisaac/luci-app-dockerman/master/Makefile -O package/luci-app-dockerman/Makefile
mkdir package/network/config/firewall/patches
cp ../lga1150/package/network/config/firewall/patches/flowoffload-connbytes.patch package/network/config/firewall/patches
cp ../lede/package/network/config/firewall/patches/fullconenat.patch package/network/config/firewall/patches
sed -i 's/46/49/g' package/network/config/firewall/patches/fullconenat.patch
cp -r ../lga1150/package/network/fullconenat package/network
cp ../lga1150/target/linux/generic/hack-5.4/952-net-conntrack-events-support-multiple-registrant.patch target/linux/generic/hack-5.4
cp ../lga1150/target/linux/generic/hack-5.4/999-make-THERMAL-tristate-again.patch target/linux/generic/hack-5.4
mkdir target/linux/ipq40xx/base-files/etc/hotplug.d/net
cp ../x-wrt/target/linux/ipq40xx/base-files/etc/hotplug.d/net/21_adjust_network target/linux/ipq40xx/base-files/etc/hotplug.d/net
cp ../x-wrt/target/linux/ipq40xx/base-files/etc/init.d/adjust_network target/linux/ipq40xx/base-files/etc/init.d
cp ../x-wrt/target/linux/ipq40xx/base-files/lib/adjust_network.sh target/linux/ipq40xx/base-files/lib
cp ../lga1150/target/linux/ipq40xx/files-5.4/arch/arm/boot/dts/qcom-ipq4019-r619ac-128m.dts target/linux/ipq40xx/files-5.4/arch/arm/boot/dts
cp ../lga1150/target/linux/ipq40xx/files-5.4/arch/arm/boot/dts/qcom-ipq4019-r619ac-32m.dts target/linux/ipq40xx/files-5.4/arch/arm/boot/dts
cp ../lga1150/target/linux/ipq40xx/files-5.4/arch/arm/boot/dts/qcom-ipq4019-r619ac-64m.dts target/linux/ipq40xx/files-5.4/arch/arm/boot/dts
cp ../lga1150/target/linux/ipq40xx/files-5.4/arch/arm/boot/dts/qcom-ipq4019-r619ac.dtsi target/linux/ipq40xx/files-5.4/arch/arm/boot/dts
cp ../x-wrt/target/linux/ipq40xx/patches-5.4/705-net-add-qualcomm-ar40xx-phy.patch target/linux/ipq40xx/patches-5.4
cp ../x-wrt/target/linux/ipq40xx/patches-5.4/715-essedma-refine-txq-to-be-adaptive-of-cpus-and-netdev.patch target/linux/ipq40xx/patches-5.4
cp ../x-wrt/target/linux/ipq40xx/patches-5.4/716-essedma-reduce-write-reg.patch target/linux/ipq40xx/patches-5.4
cp ../x-wrt/target/linux/ipq40xx/patches-5.4/901-essedma-disable-default-vlan-tagging.patch target/linux/ipq40xx/patches-5.4
cp ../x-wrt/target/linux/ipq40xx/patches-5.4/902-essedma-poll-use-napi_complete_done.patch target/linux/ipq40xx/patches-5.4
git apply diff.patch
./scripts/getver.sh
sed -i 's/192.168.1.1/192.168.7.1/g' package/base-files/files/bin/config_generate
sed -i 's/OpenWrt/P&W R619AC/g' package/base-files/files/bin/config_generate
sed -i 's/BUILD_USER=\"\"/BUILD_USER=\"Azuki\"/g' .config
sed -i 's/BUILD_DOMAIN=\"\"/BUILD_DOMAIN=\"GitHub Actions\"/g' .config
mkdir files
mkdir files/etc
mkdir files/etc/init.d
mkdir files/etc/opkg
echo $'#!/bin/sh /etc/rc.common
# Copyright (C) 2015 OpenWrt.org

START=80

USE_PROCD=1

start_service() {
	[ -d /var/log/nginx ] || mkdir -p /var/log/nginx
	[ -d /var/lib/nginx ] || mkdir -p /var/lib/nginx

	procd_open_instance
	procd_set_param command /usr/sbin/nginx -c /etc/nginx/nginx.conf -g "daemon off;"
	procd_set_param file /etc/nginx/nginx.conf
	procd_set_param respawn
	procd_close_instance
}
' > files/etc/init.d/nginx
chmod +x files/etc/init.d/nginx
echo $'#!/bin/sh /etc/rc.common

START=99

USE_PROCD=1

start_service() {
	procd_open_instance
	procd_set_param command /usr/sbin/smartdns -f -c /etc/smartdns/custom.conf
	procd_set_param respawn
	procd_close_instance
}
' > files/etc/init.d/smartdns
chmod +x files/etc/init.d/smartdns
echo $'
src/gz openwrt_core https://openwrt.proxy.ustclug.org/snapshots/targets/ipq40xx/generic/packages
src/gz openwrt_base https://openwrt.proxy.ustclug.org/snapshots/packages/arm_cortex-a7_neon-vfpv4/base
src/gz openwrt_luci https://openwrt.proxy.ustclug.org/snapshots/packages/arm_cortex-a7_neon-vfpv4/luci
src/gz openwrt_packages https://openwrt.proxy.ustclug.org/snapshots/packages/arm_cortex-a7_neon-vfpv4/packages
src/gz openwrt_routing https://openwrt.proxy.ustclug.org/snapshots/packages/arm_cortex-a7_neon-vfpv4/routing
src/gz openwrt_telephony https://openwrt.proxy.ustclug.org/snapshots/packages/arm_cortex-a7_neon-vfpv4/telephony
' > files/etc/opkg/distfeeds.conf
