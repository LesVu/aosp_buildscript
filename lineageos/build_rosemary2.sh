#!/bin/bash

# Arg 1 is lineage branch
# Arg 2 is build type
# Arg 3 is the url of the custom rom to build where the manifest is
# Arg 4 is the branch

LINEAGE_VERSION="${1:-22.2}"
BUILD_TYPE="${2:-userdebug}"
CUSTOM_ROM=$3
CUSTOM_ROM_BRANCH=$4

rm -rf .repo/local_manifests

if [ -n "$CUSTOM_ROM" ] && [ -n "$CUSTOM_ROM_BRANCH" ]; then
  repo init -u "$CUSTOM_ROM" -b "$CUSTOM_ROM_BRANCH" --git-lfs --no-clone-bundle
fi

mkdir -p .repo/local_manifests
wget "https://raw.githubusercontent.com/LesVu/aosp_buildscript/refs/heads/main/lineageos/rosemary-${LINEAGE_VERSION}.xml" \
  -O .repo/local_manifests/rosemary.xml
/opt/crave/resync.sh || repo sync -c
# shellcheck source=/dev/null
source build/envsetup.sh

if [ "$BUILD_TYPE" == "eng" ]; then
  echo "persist.sys.usb.config=adb
sys.usb.config=adb
sys.usb.state=adb
vendor.usb.config=adb" >>device/xiaomi/rosemary/system.prop

  echo "BOARD_KERNEL_CMDLINE += androidboot.selinux=permissive" >>device/xiaomi/rosemary/BoardConfig.mk
fi

croot
RELEASE=$(find "$(gettop)"/build/release/aconfig/* -maxdepth 0 -type d -name "[a-z][a-z][0-9][a-z]" -printf '%f\n' |
  tail -n1)
brunch rosemary "$BUILD_TYPE" || brunch lineage_rosemary-"$RELEASE"-"$BUILD_TYPE"
