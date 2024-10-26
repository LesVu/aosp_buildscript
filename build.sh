#!/bin/bash

rm -rf .repo/local_manifests
mkdir -p .repo/local_manifests
wget https://raw.githubusercontent.com/LesVu/lindroid/refs/heads/main/lindroid.xml -O .repo/local_manifests/lindroid.xml
/opt/crave/resync.sh
source build/envsetup.sh
breakfast rosemary

rm kernel/xiaomi/rosemary/arch/arm64/configs/rosemary_defconfig
wget https://raw.githubusercontent.com/LesVu/android_kernel_xiaomi_mt6785/refs/heads/lineage-21/arch/arm64/configs/rosemary-mod_defconfig -O kernel/xiaomi/rosemary/arch/arm64/configs/rosemary_defconfig

wget https://raw.githubusercontent.com/LesVu/lindroid/refs/heads/main/EventHub.patch
patch frameworks/native/services/inputflinger/reader/EventHub.cpp EventHub.patch

wget https://github.com/android-kxxt/android_kernel_xiaomi_sm8450/commit/ae700d3d04a2cd8b34e1dae434b0fdc9cde535c7.patch
patch kernel/xiaomi/rosemary/fs/overlayfs/util.c ae700d3d04a2cd8b34e1dae434b0fdc9cde535c7.patch

wget https://raw.githubusercontent.com/LesVu/lindroid/refs/heads/main/Ignore-uevent-s-with-null-name-for-Extcon-WiredAcces.patch
git apply Ignore-uevent-s-with-null-name-for-Extcon-WiredAcces.patch --directory=frameworks/base/

rm EventHub.patch ae700d3d04a2cd8b34e1dae434b0fdc9cde535c7.patch Ignore-uevent-s-with-null-name-for-Extcon-WiredAcces.patch

# shellcheck disable=SC2016
echo '$(call inherit-product, vendor/lindroid/lindroid.mk)' >>device/xiaomi/rosemary/lineage_rosemary.mk
echo "
# Set SELinux to permissive
BOARD_KERNEL_CMDLINE += androidboot.selinux=permissive" >>device/xiaomi/rosemary/BoardConfig.mk

sed -i '/# CONFIG_SYSVIPC is not set/d' kernel/configs/r/android-4.14/android-base.config
croot
brunch rosemary
