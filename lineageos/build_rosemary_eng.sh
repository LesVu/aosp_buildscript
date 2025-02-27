#!/bin/bash
LINEAGE_VERSION=22.1
rm -rf .repo/local_manifests
mkdir -p .repo/local_manifests
wget "https://raw.githubusercontent.com/LesVu/aosp_buildscript/refs/heads/main/lineageos/rosemary-${LINEAGE_VERSION}.xml" -O .repo/local_manifests/rosemary.xml
/opt/crave/resync.sh || repo sync
# shellcheck source=/dev/null
source build/envsetup.sh
bash "$GITHUB_WORKSPACE"/rbe.sh

breakfast lineage_rosemary-ap4a-eng

echo "persist.sys.usb.config=adb
sys.usb.config=adb
sys.usb.state=adb
vendor.usb.config=adb" >>device/xiaomi/rosemary/system.prop

croot
brunch lineage_rosemary-ap4a-eng
