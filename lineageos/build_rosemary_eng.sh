#!/bin/bash
LINEAGE_VERSION=22.1
rm -rf .repo/local_manifests
mkdir -p .repo/local_manifests
wget "https://raw.githubusercontent.com/LesVu/aosp_buildscript/refs/heads/main/lineageos/rosemary-${LINEAGE_VERSION}.xml" -O .repo/local_manifests/rosemary.xml
/opt/crave/resync.sh
source build/envsetup.sh
breakfast lineage_rosemary-ap4a-eng

rm kernel/xiaomi/mt6785/arch/arm64/configs/rosemary_defconfig
wget https://raw.githubusercontent.com/LesVu/android_kernel_xiaomi_mt6785/refs/heads/lineage-$LINEAGE_VERSION/arch/arm64/configs/rosemary-mod_defconfig -O kernel/xiaomi/mt6785/arch/arm64/configs/rosemary_defconfig

echo "persist.sys.usb.config=adb
sys.usb.config=adb
sys.usb.state=adb
vendor.usb.config=adb" >>device/xiaomi/rosemary/system.prop

sed -i '/# CONFIG_SYSVIPC is not set/d' kernel/configs/r/android-4.14/android-base.config
sed -i '/# CONFIG_FHANDLE is not set/d' kernel/configs/r/android-4.14/android-base.config
sed -i '/# CONFIG_IP6_NF_NAT is not set/d' kernel/configs/r/android-4.14/android-base.config
croot
brunch lineage_rosemary-ap4a-eng
