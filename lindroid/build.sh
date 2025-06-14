#!/bin/bash

rm -rf .repo/local_manifests
mkdir -p .repo/local_manifests
wget https://raw.githubusercontent.com/LesVu/aosp_buildscript/refs/heads/main/lindroid/lindroid.xml \
  -O .repo/local_manifests/lindroid.xml
/opt/crave/resync.sh || repo sync -c
# shellcheck source=/dev/null
source build/envsetup.sh
breakfast rosemary

rm kernel/xiaomi/mt6785/arch/arm64/configs/rosemary_defconfig
wget https://raw.githubusercontent.com/LesVu/android_kernel_xiaomi_mt6785/refs/heads/lineage-21/arch/arm64/configs/rosemary-mod_defconfig \
  -O kernel/xiaomi/mt6785/arch/arm64/configs/rosemary_defconfig

curl https://raw.githubusercontent.com/LesVu/aosp_buildscript/refs/heads/main/lindroid/EventHub.patch |
  patch frameworks/native/services/inputflinger/reader/EventHub.cpp -

curl https://github.com/android-kxxt/android_kernel_xiaomi_sm8450/commit/ae700d3d04a2cd8b34e1dae434b0fdc9cde535c7.patch |
  patch kernel/xiaomi/mt6785/fs/overlayfs/util.c -

curl https://raw.githubusercontent.com/LesVu/aosp_buildscript/refs/heads/main/lindroid/Ignore-uevent-s-with-null-name-for-Extcon-WiredAcces.patch |
  git apply --directory=frameworks/base/ -

# shellcheck disable=SC2016
echo '$(call inherit-product, vendor/lindroid/lindroid.mk)' >>device/xiaomi/rosemary/lineage_rosemary.mk
# echo "
# # Set SELinux to permissive
# BOARD_KERNEL_CMDLINE += androidboot.selinux=permissive" >>device/xiaomi/rosemary/BoardConfig.mk

sed -i '/# CONFIG_SYSVIPC is not set/d' kernel/configs/r/android-4.14/android-base.config
sed -i '/# CONFIG_FHANDLE is not set/d' kernel/configs/r/android-4.14/android-base.config
sed -i '/# CONFIG_IP6_NF_NAT is not set/d' kernel/configs/r/android-4.14/android-base.config
croot
brunch rosemary
