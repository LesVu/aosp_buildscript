#!/bin/bash

sudo apt-get update
sudo apt-get upgrade -y

sudo apt-get install -y bc bison build-essential ccache curl flex g++-multilib gcc-multilib git git-lfs gnupg gperf imagemagick lib32readline-dev lib32z1-dev libelf-dev liblz4-tool libsdl1.2-dev libssl-dev \
  libxml2 libxml2-utils lzop pngcrush rsync schedtool squashfs-tools xsltproc zip zlib1g-dev lib32ncurses5-dev libncurses5 libncurses5-dev unzip tmux python-is-python3

mkdir -p ~/bin
mkdir -p ~/android/lineage

wget https://dl.google.com/android/repository/platform-tools-latest-linux.zip
unzip platform-tools-latest-linux.zip -d ~

curl https://storage.googleapis.com/git-repo-downloads/repo >~/bin/repo
chmod a+x ~/bin/repo

# shellcheck disable=SC2016
echo '
# add Android SDK platform tools to path
if [ -d "$HOME/platform-tools" ] ; then
    PATH="$HOME/platform-tools:$PATH"
fi

# set PATH so it includes users private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

export USE_CCACHE=1
export CCACHE_EXEC=/usr/bin/ccache' >>~/.profile

source ~/.profile

git lfs install
ccache -M 50G

cd ~/android/lineage
repo init -u https://github.com/LineageOS/android.git -b lineage-21.0 --git-lfs

rm -rf .repo/local_manifests
mkdir -p .repo/local_manifests
wget https://raw.githubusercontent.com/LesVu/lindroid/refs/heads/main/lindroid.xml -O .repo/local_manifests/lindroid.xml
repo sync -j 8 -c
source build/envsetup.sh
breakfast rosemary

rm kernel/xiaomi/mt6785/arch/arm64/configs/rosemary_defconfig
wget https://raw.githubusercontent.com/LesVu/android_kernel_xiaomi_mt6785/refs/heads/lineage-21/arch/arm64/configs/rosemary-mod_defconfig -O kernel/xiaomi/mt6785/arch/arm64/configs/rosemary_defconfig

wget https://raw.githubusercontent.com/LesVu/lindroid/refs/heads/main/EventHub.patch
patch frameworks/native/services/inputflinger/reader/EventHub.cpp EventHub.patch

wget https://github.com/android-kxxt/android_kernel_xiaomi_sm8450/commit/ae700d3d04a2cd8b34e1dae434b0fdc9cde535c7.patch
patch kernel/xiaomi/mt6785/fs/overlayfs/util.c ae700d3d04a2cd8b34e1dae434b0fdc9cde535c7.patch

wget https://raw.githubusercontent.com/LesVu/lindroid/refs/heads/main/Ignore-uevent-s-with-null-name-for-Extcon-WiredAcces.patch
git apply Ignore-uevent-s-with-null-name-for-Extcon-WiredAcces.patch --directory=frameworks/base/

rm EventHub.patch ae700d3d04a2cd8b34e1dae434b0fdc9cde535c7.patch Ignore-uevent-s-with-null-name-for-Extcon-WiredAcces.patch

# shellcheck disable=SC2016
echo '$(call inherit-product, vendor/lindroid/lindroid.mk)' >>device/xiaomi/rosemary/lineage_rosemary.mk
echo "
# Set SELinux to permissive
BOARD_KERNEL_CMDLINE += androidboot.selinux=permissive" >>device/xiaomi/rosemary/BoardConfig.mk

sed -i '/# CONFIG_SYSVIPC is not set/d' kernel/configs/r/android-4.14/android-base.config
sed -i '/# CONFIG_FHANDLE is not set/d' kernel/configs/r/android-4.14/android-base.config
sed -i '/# CONFIG_IP6_NF_NAT is not set/d' kernel/configs/r/android-4.14/android-base.config
croot
brunch rosemary
