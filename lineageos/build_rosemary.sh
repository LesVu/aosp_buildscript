#!/bin/bash

rm -rf .repo/local_manifests
mkdir -p .repo/local_manifests
wget https://raw.githubusercontent.com/LesVu/lindroid/refs/heads/main/lineageos/rosemary.xml -O .repo/local_manifests/rosemary.xml
/opt/crave/resync.sh
source build/envsetup.sh
breakfast rosemary

rm kernel/xiaomi/mt6785/arch/arm64/configs/rosemary_defconfig
wget https://raw.githubusercontent.com/LesVu/android_kernel_xiaomi_mt6785/refs/heads/lineage-21/arch/arm64/configs/rosemary-mod_defconfig -O kernel/xiaomi/mt6785/arch/arm64/configs/rosemary_defconfig

sed -i '/# CONFIG_SYSVIPC is not set/d' kernel/configs/r/android-4.14/android-base.config
sed -i '/# CONFIG_FHANDLE is not set/d' kernel/configs/r/android-4.14/android-base.config
sed -i '/# CONFIG_IP6_NF_NAT is not set/d' kernel/configs/r/android-4.14/android-base.config
croot
brunch rosemary
